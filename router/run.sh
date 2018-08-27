#!/bin/sh
containerName=router

docker create --rm --name $containerName --cap-add=NET_ADMIN --network lan --ip 10.1.1.10 rpi3-router
containerId=$(docker ps -aqf "name=$containerName")
echo $containerId
docker network connect lantowan0 $containerId
docker network connect lantowan1 $containerId
docker start $containerId
