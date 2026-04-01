#!/bin/sh

echo "{\"event_name\":\"camera_lost\", \"date\":\"$2\",\"host\":\"$3\",\"camera_id\":\"$4\",\"event_id\":\"$5\"}" >> $1
