#!/bin/bash

for i in `find /sys/devices/ -name scan`; do 
	echo "- - -" > $i
	echo  $i scan finished.
done
echo finished
