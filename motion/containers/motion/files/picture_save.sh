#!/bin/sh

echo "{\"event_name\":\"picture_save\", \"date\":\"$2\",\"host\":\"$3\",\"camera_id\":\"$4\",\"event_id\":\"$5\", \"file\":\"$6\"}" >> $1
