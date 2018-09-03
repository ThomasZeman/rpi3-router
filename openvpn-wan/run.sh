#!/bin/sh

modprobe tun
if [ ! $? -eq 0 ]; then
  echo "Cannot load module 'tun'"
  exit 1
fi 

containerName=openvpn

docker create --rm --name $containerName --cap-add=NET_ADMIN --mount source=rpi3-openvpn-data,target=/data \
--device /dev/net/tun --network=lantowan1 rpi3-openvpn

containerId=$(docker ps -aqf "name=$containerName")
echo $containerId
docker network connect wan $containerId
docker start $containerId

