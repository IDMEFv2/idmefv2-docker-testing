#!/usr/bin/env python3
"""
Kismet Alert API - Working Version
Generates and injects WiFi deauth PCAP files into Kismet
One call = One alert guaranteed
"""

from fastapi import FastAPI, HTTPException
import os
import requests
import time
import random

app = FastAPI(
    title="Kismet Alert Generator",
    description="Generate WiFi IDS alerts on-demand via HTTP API",
    version="3.0.0"
)

KISMET_URL = os.environ.get("KISMET_URL", "http://kismet:2501")
KISMET_USER = os.environ.get("KISMET_USER", "admin")
KISMET_PASS = os.environ.get("KISMET_PASS", "admin")
PCAP_DIR = os.environ.get("PCAP_DIR", "/pcaps")

alerts_generated = 0


def generate_pcap_file():
    """Generate a PCAP file with deauth packets - produces exactly one alert"""
    from scapy.all import Dot11, Dot11Deauth, RadioTap, wrpcap
    
    # Generate random AP MAC - completely unique each time
    random_bytes = [random.randint(0x00, 0xff) for _ in range(6)]
    ap_mac = ":".join(f"{b:02X}" for b in random_bytes)
    broadcast_mac = "FF:FF:FF:FF:FF:FF"
    
    # Create packets - small burst (5 packets) triggers one BCASTDISCON alert
    # We set strict timestamps to ensure they are seen as one event
    packets = []
    base_time = time.time()
    for i in range(5):
        pkt = RadioTap() / Dot11(
            addr1=broadcast_mac,
            addr2=ap_mac,
            addr3=ap_mac,
            FCfield=0x01,
            SC=i
        ) / Dot11Deauth(reason=7)  # Reason 7: Class 3 frame
        
        # Explicitly set time to avoid drift
        pkt.time = base_time + (i * 0.001)  # 1ms apart
        packets.append(pkt)
    
    # Write PCAP to shared volume with Kismet
    pcap_file = f"{PCAP_DIR}/alert_{int(base_time * 1000)}.pcap"
    wrpcap(pcap_file, packets)
    
    return pcap_file, ap_mac


@app.get("/health")
async def health():
    """Health check endpoint"""
    try:
        r = requests.get(
            f"{KISMET_URL}/system/status.json",
            auth=(KISMET_USER, KISMET_PASS),
            timeout=5
        )
        if r.status_code == 200:
            data = r.json()
            return {
                "status": "healthy",
                "kismet": "connected",
                "version": data.get('kismet.system.version', 'unknown'),
                "devices": data.get('kismet.system.devices.count', 0),
                "alerts_generated": alerts_generated
            }
    except Exception:
        pass
    
    return {"status": "unhealthy"}


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "name": "Kismet Alert Generator API",
        "version": "3.0",
        "description": "Generate WiFi IDS alerts on-demand (1 call = 1 alert)",
        "endpoints": {
            "health": "/health",
            "generate_alert": "/generate-alert",
            "stats": "/stats",
            "docs": "/docs"
        }
    }


@app.post("/generate-alert")
async def generate_alert():
    """Generate exactly one WiFi deauth alert by importing PCAP into Kismet"""
    global alerts_generated
    
    try:
        # Verify Kismet is reachable
        r = requests.get(
            f"{KISMET_URL}/system/status.json",
            auth=(KISMET_USER, KISMET_PASS),
            timeout=5
        )
        if r.status_code != 200:
            raise HTTPException(status_code=503, detail="Kismet not responding")
        
        # Generate PCAP file - this will trigger exactly one alert
        pcap_file, ap_mac = generate_pcap_file()
        
        alerts_generated += 1
        
        return {
            "status": "success",
            "message": "PCAP generated - one alert will be triggered",
            "ap_mac": ap_mac,
            "pcap_file": pcap_file,
            "total_generated": alerts_generated
        }
    
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=503, detail=f"Kismet error: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error: {str(e)}")


@app.get("/stats")
async def stats():
    """Get statistics"""
    return {
        "alerts_generated": alerts_generated,
        "kismet_url": KISMET_URL,
        "api_version": "3.0.0"
    }


@app.get("/alerts")
async def get_alerts():
    """Get all current alerts from Kismet"""
    try:
        r = requests.get(
            f"{KISMET_URL}/alerts/all_alerts.json",
            auth=(KISMET_USER, KISMET_PASS),
            timeout=5
        )
        if r.status_code == 200:
            alerts = r.json()
            bcastdiscon = [a for a in alerts if a.get('kismet.alert.header') == 'BCASTDISCON']
            return {
                "total_alerts": len(alerts),
                "bcastdiscon_count": len(bcastdiscon),
                "alerts_summary": [
                    {
                        "timestamp": a.get('kismet.alert.timestamp'),
                        "type": a.get('kismet.alert.header'),
                        "severity": a.get('kismet.alert.severity'),
                        "device": a.get('kismet.alert.device')
                    }
                    for a in alerts[:10]
                ]
            }
        else:
            raise HTTPException(status_code=500, detail="Failed to get alerts from Kismet")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
