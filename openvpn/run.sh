#!/bin/sh

modprobe tun
if [ ! $? -eq 0 ]; then
  echo "Cannot load module 'tun'"
  exit 1
fi 

docker run -d --rm --name openvpn --cap-add=NET_ADMIN --mount source=rpi3-openvpn-data,target=/data \
--device /dev/net/tun --network=net1 rpi3-openvpn
