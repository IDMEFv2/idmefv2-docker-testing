#!/bin/bash

echo "=========================================="
echo "  Samhain Alert Simulation"
echo "=========================================="
echo ""

LOG_FILE="/var/log/samhain/samhain.log"

echo "[1/5] Modifying config.txt..."
echo "SUSPICIOUS MODIFICATION - $(date)" >> /monitored/sensitive/config.txt
sleep 2

echo "[2/5] Modifying passwords.txt..."
echo "new_password_123 - $(date)" >> /monitored/sensitive/passwords.txt
sleep 2

echo "[3/5] Changing permissions on system.conf..."
chmod 644 /monitored/sensitive/system.conf
sleep 2

echo "[4/5] Creating new suspicious file..."
echo "Malicious file created - $(date)" > /monitored/sensitive/malicious.txt
sleep 2

echo "[5/5] Modifying system file /etc/passwd (adding comment)..."
# Add only a comment to avoid breaking the system
echo "# Test modification - $(date)" >> /etc/passwd
sleep 2

echo ""
echo "=========================================="
echo "  Simulation completed!"
echo "=========================================="
echo ""
echo "Samhain will detect modifications on the next check cycle."
echo "The check cycle is configured every 60 seconds."
echo ""
echo "To view alerts in real-time:"
echo "  tail -f /var/log/samhain/samhain.log"
echo ""
echo "Or from the host:"
echo "  docker exec samhain tail -f /var/log/samhain/samhain.log"
echo ""

# Force an immediate check if possible
if command -v samhain &> /dev/null; then
    echo "[INFO] Forcing immediate check..."
    samhain -t check 2>/dev/null || true
fi
