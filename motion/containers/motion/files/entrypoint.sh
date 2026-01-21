#!/bin/sh

BACKUP="/etc/motion/motion.conf.bak"
if [ ! -f "$BACKUP" ]; then
  ./configure.sh
fi

# Initialize the motion detection log file
mkdir -p /var/log/motion/
touch /var/log/motion/events.json

# start the connector
python3 -m idmefv2.connectors.motion -c /etc/motion-idmefv2.conf &

motion -n
