#!/bin/sh

cd hostapd
./build.sh
cd ../dhcpd
./build.sh
cd ../eth-lan
./build.sh
cd ../router
./build.sh
cd ../base-wan
./build.sh
cd ../passthrough-wan
./build.sh
cd ../wireguard-wan
./build.sh
cd ../eth-wan
./build.sh
cd ..
