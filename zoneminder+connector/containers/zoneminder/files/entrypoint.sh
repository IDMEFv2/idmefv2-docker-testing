#! /bin/sh

set -e

# install IDMEFv2 connectors
cd /idmefv2-connectors
pip install --force-reinstall --editable .
# simplify path of script
rm -f /zm2json.sh
ln -s /idmefv2-connectors/idmefv2/connectors/zoneminder/zm2json.sh /zm2json.sh

# Prepare log file (path is defined in connector configuration file)
mkdir -p /var/log/zmjson/
touch /var/log/zmjson/events.json
chown www-data.www-data -R /var/log/zmjson/

# start the connector
python3 -m idmefv2.connectors.zoneminder -c /etc/zoneminder-idmefv2.conf &

# run the zobeminder startup script
/etc/my_init.d/startup.sh
