#!/bin/sh

ip addr flush dev eth0

ip route add 10.1.1.0/24 via 10.1.2.2

touch /etc/resolv.1.conf

/usr/sbin/dhclient eth0

/usr/sbin/dnsmasq --conf-file=/etc/dnsmasq.conf

iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -j MASQUERADE

term_handler() {
        kill -TERM $sleepPid
        exit 143;
}

trap term_handler SIGTERM

sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"


