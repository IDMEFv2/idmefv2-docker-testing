#!/bin/sh

echo "{\"event_name\":\"movie_end\", \"date\":\"$2\",\"host\":\"$3\",\"camera_id\":\"$4\",\"event_id\":\"$5\", \"file\":\"$6\"}" >> $1
