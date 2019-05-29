#!/bin/sh

echo "The raspberry pi 3 does not have enough RAM to build cloudflared. Creating swap file"

fallocate -l 2G /swapfile
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

docker build . -t rpi3-cloudflared --network=host

swapoff /swapfile
rm /swapfile
