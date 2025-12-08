#! /bin/sh

set -e

# install IDMEFv2 connectors
cd /idmefv2-connectors
pip install --force-reinstall .

# run the zobeminder startup script
/etc/my_init.d/startup.sh
