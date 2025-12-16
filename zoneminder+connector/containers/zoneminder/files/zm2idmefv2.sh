#!/bin/sh

LOGFILE=/var/log/idmefv2/zoneminder-connector.log
echo "ARGS $*" >> $LOGFILE
/usr/bin/python3 -m idmefv2.connectors.zoneminder -c /etc/zoneminder-idmefv2.conf "$1" "$2" "$3" "$4" "$5" >> $LOGFILE 2>&1
echo "RET $?" >> $LOGFILE

exit 0
