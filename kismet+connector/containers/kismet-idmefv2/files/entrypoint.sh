#! /bin/sh

set -e

# install IDMEFv2 connectors
cd /idmefv2-connectors
pip install --break-system-packages --force-reinstall .

python3 -m idmefv2.connectors.kismet -c /etc/kismet-idmefv2.conf
