#!/bin/bash

set -e

# install IDMEFv2 connectors
cd /idmefv2-connectors
pip install --break-system-packages .

# run the Wazuh IDMEFv2 connector
python3 -m idmefv2.connectors.wazuh -c /etc/wazuh-idmefv2.conf
