#! /bin/sh

set -e

# install IDMEFv2 connectors
cd /idmefv2-connectors
pip install --break-system-packages --force-reinstall .

# Ensure log file exists (it should be mounted, but just in case)
touch /var/log/samhain/samhain.log

python3 -m idmefv2.connectors.samhain -c /etc/samhain-idmefv2.conf
