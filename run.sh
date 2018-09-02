#!/bin/sh

hostapd/run.sh start
dhcpd/run.sh
router/run.sh
directwan/run.sh
openvpn/run.sh
