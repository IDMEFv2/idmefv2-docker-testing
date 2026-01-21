#!/bin/sh

CONF="/etc/motion/motion.conf"
BACKUP="/etc/motion/motion.conf.bak"

# Backup original configuration file
cp "$CONF" "$BACKUP" || {
    echo "Error : Unable to create the backup file"
    exit 1
}

# Allow access to webcontrol and camera stream from LAN
sed -i \
    -e 's/^webcontrol_localhost[[:space:]]\+on/webcontrol_localhost off/' \
    -e 's/^stream_localhost[[:space:]]\+on/stream_localhost off/' \
    "$CONF"

echo "" >> /etc/motion/motion.conf
echo picture_output on >> /etc/motion/motion.conf
echo snapshot_interval 0.5 >> /etc/motion/motion.conf
echo on_picture_save /picture_save.sh /var/log/motion/events.json \"%Y-%m-%d %T\" %{host} %t %v \"%f\">> /etc/motion/motion.conf

echo "Configuration has been updated."
echo "Backup file : $BACKUP"