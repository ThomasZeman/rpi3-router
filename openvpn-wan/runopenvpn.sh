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

touch /etc/resolv.1.conf

/usr/sbin/dhclient eth0

# This is annoying to have but necessary with the basic openvpn setup
# openvpn server side would need to know how to route 10.1.0.0/16 pakets
# It should be enough to masquerade on the end which owns the public ip
iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -j MASQUERADE

exec /usr/sbin/openvpn --config /data/client.ovpn

