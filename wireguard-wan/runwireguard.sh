#!/bin/sh

# trap signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

# ip addr flush dev eth0
ip route del default
ip route add 10.0.0.0/24 via 10.1.2.1

# Promise is: Either traffic goes through VPN or gets rejected
# We do not want traffic to 'leak' accidently when VPN is down
iptables -A FORWARD -s 10.0.0.0/8 -o eth0 -j REJECT

# This prohibits local dns being used and having dns leakage
# However, using 1.1.1.1 as a default is not great either. Best
# would be wg sets the nameserver of the server 

echo "nameserver 1.1.1.1" > /etc/resolv.conf

iptables -t nat -A POSTROUTING -s 10.0.0.0/8 -j MASQUERADE

# Find Peer section, find endpoint key value and print value, find ip:port and print ip, remove spaces
SERVER_ENDPOINT=$(sed -n '/\[Peer\]/,/\[.*\]/p' /data/wg0.conf | awk -F= '/Endpoint/{print $2}' | awk -F: '{print $1}' | tr -d ' ')

if [ -z "$SERVER_ENDPOINT" ]
then
  echo "Cannot parse server endpoint"
  cat /data/wg0.conf
  exit 1
fi

ip route add $SERVER_ENDPOINT via 10.1.0.100

wg-quick up /data/wg0.conf

/usr/sbin/dnsmasq --conf-file=/etc/dnsmasq.conf

term_handler() {
        kill -SIGTERM $dhcpdPid
        kill -TERM $sleepPid
}

trap term_handler SIGTERM

echo "Waiting for SIGTERM"
sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"

wg-quick down /data/wg0.conf
