#!/bin/bash
set -e

container_name="solvcon-master"

sep_liner=`printf "%0.s-" {1..100}`
echo `docker inspect $container_name | grep -iw ipaddress`

echo $sep_liner
echo -e "\n-- Server's stdout --\n"
docker logs $container_name
echo $sep_liner

echo -e "\n-- Server's processes --\n"
docker top $container_name
echo $sep_liner
