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

iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -j MASQUERADE

exec /usr/bin/wg setconf wg0 /data/client.wgconf

term_handler() {
        kill -SIGTERM $dhcpdPid
        kill -TERM $sleepPid
}

trap term_handler SIGTERM

echo "Waiting for SIGTERM"
sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"

