#!/bin/bash

# install IDMEFv2 connectors
cd /idmefv2-connectors
pip install --break-system-packages --editable .

# debug the Wazuh IDMEFv2 connector
pip install --break-system-packages debugpy
python3 -Xfrozen_modules=off -m debugpy --listen 0.0.0.0:5678 --wait-for-client -m idmefv2.connectors.clamav -c /etc/clamav-idmefv2.conf