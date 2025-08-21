#! /bin/sh

set -e

# install IDMEFv2 GLPI addon
cd /idmefv2-glpi-addon
pip install --break-system-packages .

python3 -m idmefv2.addon.glpi -c /etc/glpi-addon.conf
