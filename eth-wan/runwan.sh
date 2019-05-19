#!/bin/sh

ethif=eth2

# Waiting 10 seconds for wlan interface to come up / be transfered to container namespace

counter=0
until [ -e "/sys/class/net/$ethif" ] || [ $counter -eq 1200 ]; do
  sleep 1
  echo "Waiting for interface '$ethif' to become available... $((counter++))"
done

if [ ! -e "/sys/class/net/$ethif" ]; then
  echo "Giving up. Make sure interface has been set to namespace of container"
  exit 1
fi

ip route del default
ip addr flush dev $ethif
ip route add 10.0.0.0/24 via 10.1.0.1
ip route add 10.1.1.0/24 via 10.1.0.1
ip route add 10.1.2.0/24 via 10.1.0.2

/usr/sbin/dhclient $ethif

iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -j MASQUERADE

term_handler() {
        kill -TERM $sleepPid
        exit 143;
}

trap term_handler SIGTERM

sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"


