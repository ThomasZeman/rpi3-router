#!/bin/sh
containerName=directwan

docker create --rm --name $containerName --cap-add=NET_ADMIN --network lantowan0 rpi3-directwan
containerId=$(docker ps -aqf "name=$containerName")
echo $containerId
docker network connect wan $containerId
docker start $containerId
