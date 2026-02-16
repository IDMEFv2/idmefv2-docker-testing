#!/bin/bash
set -e

# Find Kismet binary
if [ -f /usr/local/bin/kismet ]; then
    KISMET_BIN="/usr/local/bin/kismet"
else
    KISMET_BIN="kismet"
fi

echo "[ENTRYPOINT] Starting Kismet..."
$KISMET_BIN --no-ncurses &
KISMET_PID=$!

echo "[ENTRYPOINT] Kismet started (PID: $KISMET_PID), waiting for startup..."
sleep 10

echo "[ENTRYPOINT] Setting up PCAP file monitor..."

# Monitor /pcaps directory for new PCAP files
inotifywait -m -e create,close_write /pcaps 2>/dev/null | while read path action file; do
    if [[ "$file" =~ \.pcap$ ]]; then
        full_path="${path}${file}"
        echo "[MONITOR] Detected new PCAP file: $full_path"
        sleep 1
        
        echo "[MONITOR] Injecting $full_path into Kismet..."
        /usr/local/bin/kismet_cap_pcapfile \
            --connect localhost:2501 \
            --user admin \
            --password admin \
            --source "$full_path" 2>&1 &
    fi
done &

# Keep the Kismet process running
wait $KISMET_PID
