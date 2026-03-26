#!/bin/bash

set -e

cd /idmefv2-connectors
git config --global --add safe.directory /idmefv2-connectors
pip install --break-system-packages --force-reinstall .

runuser -u elastalert /opt/elastalert/run.sh
