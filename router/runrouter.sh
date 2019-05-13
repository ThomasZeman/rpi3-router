#!/bin/sh

iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark --nfmask 0xffffffff --ctmask 0xffffffff
iptables -t mangle -N PREROUTING_MARKING
iptables -t mangle -A PREROUTING -j PREROUTING_MARKING

# Enable for ulogd logging ( https://it-offshore.co.uk/linux/alpine-linux/55-alpine-linux-lxc-guest-iptables-logging )
# iptables -t mangle -A PREROUTING -s 10.1.1.0/24 -j NFLOG --nflog-prefix "P1:"

iptables -t nat -A PREROUTING -p udp -m udp -d 10.1.1.10 --dport 53 -m mark --mark 0x3 -j DNAT --to-destination 10.1.3.3:53
iptables -t nat -A PREROUTING -p tcp -m tcp -d 10.1.1.10 --dport 53 -m mark --mark 0x3 -j DNAT --to-destination 10.1.3.3:53
iptables -t nat -A PREROUTING -p udp -m udp -d 10.1.1.10 --dport 53 -m mark --mark 0x2 -j DNAT --to-destination 10.1.2.3:53
iptables -t nat -A PREROUTING -p tcp -m tcp -d 10.1.1.10 --dport 53 -m mark --mark 0x2 -j DNAT --to-destination 10.1.2.3:53

# Only LAN is allowed to talk to local processes

iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 10.1.1.0/24 -j ACCEPT

# No default route. All routes set up explicitly
ip route del default

ip route add default via 10.1.2.3 table 2
ip route add default via 10.1.3.3 table 3

export FLASK_APP=routeconfigurator.py
export FLASK_ENV=production
exec flask run --host=10.1.1.10 --port=80

