#!/bin/sh

cd hostapd
./build.sh
cd ../dhcpd
./build.sh
cd ../wanbase
./build.sh
cd ../openvpn
./build.sh
cd ../directwan
./build.sh
cd ..
