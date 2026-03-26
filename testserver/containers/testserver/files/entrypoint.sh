#!/bin/bash

# install IDMEFv2 connectors
cd /idmefv2-connectors
git config --global --add safe.directory /idmefv2-connectors
pip install --break-system-packages .

# run the test server
python3 -m idmefv2.connectors.testserver --port 9999 --log-level DEBUG
