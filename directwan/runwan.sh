#!/bin/sh

# trap signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

/usr/sbin/dnsmasq --conf-file=/etc/dnsmasq.conf

while true; do sleep 1; done
