#!/bin/sh

CONF="/etc/motion/motion.conf"
BACKUP="/etc/motion/motion.conf.bak"
if [ ! -f "$BACKUP" ]; then
    cp "$CONF" "$BACKUP" || {
        echo "Error : Unable to create the backup file"
        exit 1
    }
fi

cp "$BACKUP" "$CONF" || {
    echo "Error : Unable to restore the backup file"
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
echo on_camera_lost /camera_lost.sh /var/log/motion/events.json \"%Y-%m-%d %T\" %{host} %t %v>> /etc/motion/motion.conf
echo on_event_start /event_start.sh /var/log/motion/events.json \"%Y-%m-%d %T\" %{host} %t %v>> /etc/motion/motion.conf
echo on_event_end /event_end.sh /var/log/motion/events.json \"%Y-%m-%d %T\" %{host} %t %v>> /etc/motion/motion.conf
echo on_movie_end /movie_end.sh /var/log/motion/events.json \"%Y-%m-%d %T\" %{host} %t %v \"%f\">> /etc/motion/motion.conf


# install IDMEFv2 connectors
cd /idmefv2-connectors
echo Installing connector dependencies
pip install --force-reinstall --editable .
# simplify path of script
rm -f /motion2json.sh
ln -s /idmefv2-connectors/idmefv2/connectors/motion/motion2json.sh /motion2json.sh

# Initialize the motion detection log file
mkdir -p /var/log/motion/
touch /var/log/motion/events.json

# start the connector
python3 -m idmefv2.connectors.motion -c /etc/motion-idmefv2.conf &

motion -n
