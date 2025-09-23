#!/bin/bash
STATUS_SLEEP_INTERVAL=20

/var/ossec/bin/wazuh-control start
status=$?
if [ $status -ne 0 ]; then exit $status ; fi

while true ; do
  sleep $STATUS_SLEEP_INTERVAL
  /var/ossec/bin/wazuh-control status > /dev/null 2>&1
  status=$?
  if [ $status -ne 0 ] ; then exit $status ; fi
done
