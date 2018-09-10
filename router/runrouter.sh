#!/bin/sh

iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark --nfmask 0xffffffff --ctmask 0xffffffff
iptables -t mangle -A PREROUTING -s 10.1.1.100/32 -j MARK --set-xmark 0x2/0xffffffff
iptables -t mangle -A PREROUTING -s 10.1.1.103/32 -j MARK --set-xmark 0x3/0xffffffff
iptables -t mangle -A PREROUTING -s 10.1.1.9/32 -j MARK --set-xmark 0x2/0xffffffff
iptables -t mangle -A PREROUTING -s 10.1.1.101/32 -j MARK --set-xmark 0x2/0xffffffff

# Enable for ulogd logging ( https://it-offshore.co.uk/linux/alpine-linux/55-alpine-linux-lxc-guest-iptables-logging )
# iptables -t mangle -A PREROUTING -s 10.1.1.0/24 -j NFLOG --nflog-prefix "P1:"

iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -m mark --mark 0x3 -j DNAT --to-destination 10.1.3.3:53
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -m mark --mark 0x3 -j DNAT --to-destination 10.1.3.3:53
iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -m mark --mark 0x2 -j DNAT --to-destination 10.1.2.3:53
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -m mark --mark 0x2 -j DNAT --to-destination 10.1.2.3:53

# Pakets w/o mark are defaulting to 10.1.2.3
ip route del default
#ip route add default via 10.1.2.3

ip route add default via 10.1.2.3 table 2
ip route add default via 10.1.3.3 table 3

ip rule add fwmark 2 table 2 prio 40000
ip rule add fwmark 3 table 3 prio 40001

term_handler() {
	kill -TERM $sleepPid
}

trap term_handler SIGTERM

gunicorn -b 0.0.0.0:80 --daemon routeconfigurator:app

get_pid() {
        gunicornPid=$(ps auxw | grep /gunicorn | grep -v grep | awk '{print $1}')
}


sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"

get_pid()

kill -SIGTERM $gunicornPid
