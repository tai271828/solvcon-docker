#!/bin/bash
set -e

container_name="solvcon-master"
image_name=$container_name

ipv4_regex="([0-9]{1,3}[\.]){3}[0-9]{1,3}"

docker run -d --name $container_name --privileged $image_name $@

nfsip=`docker inspect $container_name | grep -iw ipaddress | grep -Eo $ipv4_regex`

# Source the script to populate MYNFSIP env var
export MYNFSIP=$nfsip

echo "Nfs Server IP: "$MYNFSIP
