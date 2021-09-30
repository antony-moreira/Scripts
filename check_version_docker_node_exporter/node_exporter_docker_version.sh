#!/bin/bash
 
#--------------------------------VARIABLES--------------------------------------------------

CONTAINER_ID="/opt/scripts/containers_ID.txt"
CONTAINER_VERSION="/opt/scripts/versão_id.txt"


#--------------------------------EXECUTION----------------------------------------------------
rm /var/lib/prometheus/node-exporter/*.prom

docker ps -a --format "{{.ID}}" > /opt/scripts/containers_ID.txt
 
docker container inspect $(cat $CONTAINER_ID) | jq -r '.[].Config.Image' | sed 's/\./_/;s/\./_/;s/\:/_/' > /opt/scripts/versão_id.txt

while read -r line 
do 
line2=$( echo "$line" | cut -d _ -f1)
touch /var/lib/prometheus/node-exporter/"$line2".prom
echo "# HELP to find docker version DOCKER metric docker_version
#TYPE docker_version
docker_version_"$line" 0" > /var/lib/prometheus/node-exporter/"$line2".prom
done < $CONTAINER_VERSION
