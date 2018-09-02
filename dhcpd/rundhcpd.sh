#!/bin/sh

touch /data/dhcpd.leases

cat > /etc/dhcp/dhcpd.conf << '__EOF__'
authoritative;

subnet 10.1.1.0 netmask 255.255.255.0 {
  range 10.1.1.100 10.1.1.200;
  option routers 10.1.1.10;
  option domain-name-servers 10.1.1.10;
}
__EOF__

/usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf -lf /data/dhcpd.leases

dhcpdPid=$(ps auxw | grep /dhcpd | grep -v grep | awk '{print $1}')

term_handler() {
        kill -SIGTERM $dhcpdPid
        kill -TERM $sleepPid
        exit 143;
}

trap term_handler SIGTERM

echo "Waiting for dhcpd to exit"
sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"
