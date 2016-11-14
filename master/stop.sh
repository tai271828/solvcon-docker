#!/bin/bash
set -e

container_name="solvcon-master"

docker stop $container_name
docker rm $container_name
