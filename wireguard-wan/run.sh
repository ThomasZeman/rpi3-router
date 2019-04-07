#!/bin/sh

echo "Requires wireguard module installed in host system"

modprobe wireguard

containerName=wireguard

docker create --name $containerName --cap-add=NET_ADMIN --mount source=rpi3-wireguard-data,target=/data --network=lantowan1 rpi3-wireguard-wan

containerId=$(docker ps -aqf "name=$containerName")
echo $containerId
docker network connect wan $containerId
docker start $containerId

