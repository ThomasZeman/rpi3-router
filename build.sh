#!/bin/sh

cd hostapd
./build.sh
cd ../dhcpd
./build.sh
cd ../base-wan
./build.sh
cd ../openvpn-wan
./build.sh
cd ../eth-wan
./build.sh
cd ..
