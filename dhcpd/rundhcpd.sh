#!/bin/sh

touch /data/dhcpd.leases

cat > /etc/dhcp/dhcpd.conf << '__EOF__'
authoritative;

subnet 10.0.0.0 netmask 255.255.255.0 {
  range 10.0.0.100 10.0.0.200;
  option routers 10.0.0.1;
  option domain-name-servers 10.0.0.1;
  option interface-mtu 1420;
}
__EOF__

/usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf -lf /data/dhcpd.leases

dhcpdPid=$(ps auxw | grep /dhcpd | grep -v grep | awk '{print $1}')

term_handler() {
        kill -SIGTERM $dhcpdPid
        kill -TERM $sleepPid
}

trap term_handler SIGTERM

echo "Waiting for SIGTERM"
sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"
