#!/bin/bash
set -e

echo "=========================================="
echo "  Samhain HIDS - Initialization"
echo "=========================================="

# Ensure directories exist
mkdir -p /var/log/samhain
mkdir -p /var/lib/samhain
mkdir -p /monitored/sensitive

# Fix permissions on log directory (needed for Docker bind mounts)
chmod 755 /var/log/samhain 2>/dev/null || true
chown root:root /var/log/samhain 2>/dev/null || true

# Create test files if they don't exist
if [ ! -f /monitored/sensitive/config.txt ]; then
    echo "Original sensitive file - $(date)" > /monitored/sensitive/config.txt
fi
if [ ! -f /monitored/sensitive/passwords.txt ]; then
    echo "Simulated password file - $(date)" > /monitored/sensitive/passwords.txt
fi
if [ ! -f /monitored/sensitive/system.conf ]; then
    echo "Critical system file - $(date)" > /monitored/sensitive/system.conf
fi

# Set correct permissions
chmod 600 /monitored/sensitive/*

echo "[INFO] Creating initial file database..."

# Initialize samhain database (baseline)
if [ ! -f /var/lib/samhain/samhain_file ]; then
    echo "[INFO] First startup - creating filesystem baseline..."
    samhain -t init
    echo "[INFO] Baseline created successfully!"
else
    echo "[INFO] Existing baseline found."
fi

echo ""
echo "=========================================="
echo "  Starting Samhain in check mode"
echo "=========================================="
echo ""
echo "Log file: /var/log/samhain/samhain.log"
echo "To simulate alerts, run in another terminal:"
echo "  docker exec samhain /simulate_alerts.sh"
echo ""
echo "Or manually modify files in /monitored/sensitive/"
echo ""
echo "=========================================="

# Start samhain in loop for continuous monitoring
# Runs a check every 60 seconds
while true; do
    samhain -t check >/dev/null 2>&1
    sleep 60
done
