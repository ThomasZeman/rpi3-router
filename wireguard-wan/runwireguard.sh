#!/bin/sh

# trap signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

ip addr flush dev eth0

ip route add 10.1.1.0/24 via 10.1.3.2

# Promise is: Either traffic goes through VPN or gets rejected
# We do not want traffic to 'leak' accidently when VPN is down
iptables -A FORWARD -s 10.1.0.0/16 -o eth0 -j REJECT

# This prohibits local dns being used and having dns leakage
# However, using 1.1.1.1 as a default is not great either. Best
# would be wg sets the nameserver of the server 

echo "nameserver 1.1.1.1" > /etc/resolv.conf

/usr/sbin/dhclient eth0

# Sleep is not an acceptable solution but dhclient will be removed
sleep 2

iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -j MASQUERADE

# wg-quick changes the default route and does not setup a route to the vpn server via the previous default route. Not sure why 
# or what the thoughts behind this behavior are. Parsing current default gatway and vpn server endpoint and setting route manually.

DEFAULT_GATEWAY=$(ip route | awk '{if ($1=="default") print $3}')

if [ -z "$DEFAULT_GATEWAY" ]
then
  echo "Cannot determine default gateway"
  ip route
  exit 1
fi

# Find Peer section, find endpoint key value and print value, find ip:port and print ip, remove spaces
SERVER_ENDPOINT=$(sed -n '/\[Peer\]/,/\[.*\]/p' /data/wg0.conf | awk -F= '/Endpoint/{print $2}' | awk -F: '{print $1}' | tr -d ' ')

if [ -z "$SERVER_ENDPOINT" ]
then
  echo "Cannot parse server endpoint"
  cat /data/wg0.conf
  exit 1
fi

ip route add $SERVER_ENDPOINT via $DEFAULT_GATEWAY

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
