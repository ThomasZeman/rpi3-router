#!/bin/sh

docker run -d --rm --name dhcpd --mount source=rpi3-dhcpd-data,target=/data --network=lan rpi3-dhcpd
