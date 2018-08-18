#!/bin/sh

if [ "$1" == "start" ]; then
  docker run -d --rm --name hostapd --cap-add=NET_ADMIN --device=/dev/rfkill --network=none rpi3-hostapd
fi

wifiContainerId=$(docker ps -aqf "name=hostapd")
wifiPid=$(docker inspect -f '{{.State.Pid}}' $wifiContainerId)

if [ "$1" == "start" ]; then
  ln -s /proc/$wifiPid/ns/net /var/run/netns/$wifiPid
  iw phy phy0 set netns $wifiPid
fi

if [ "$1" == "stop" ]; then
  wifiContainerId=$(docker ps -aqf "name=hostapd")
  wifiPid=$(docker inspect -f '{{.State.Pid}}' $wifiContainerId)
  docker stop $wifiContainerId
  rm /var/run/netns/$wifiPid
fi
