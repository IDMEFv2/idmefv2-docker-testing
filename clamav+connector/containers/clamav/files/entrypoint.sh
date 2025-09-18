#!/bin/bash

freshclam

chown clamav:clamav /var/tmp/clamav

clamd --foreground
