#!/bin/sh

echo "{\"event_name\":\"event_start\", \"date\":\"$2\",\"host\":\"$3\",\"camera_id\":\"$4\",\"event_id\":\"$5\"}" >> $1
