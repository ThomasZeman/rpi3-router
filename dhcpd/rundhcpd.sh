#!/bin/sh

touch /data/dhcpd.leases

cat /data/dns_update_key > /etc/dhcp/dhcpd.conf

cat >> /etc/dhcp/dhcpd.conf << '__EOF__'

authoritative;

option domain-name "lan";
ddns-updates on;
ddns-update-style interim;
ddns-domainname "lan";
ddns-rev-domainname "in-addr.arpa";

ignore client-updates;

zone lan. {
  primary 10.0.0.9;
  key dns_update_key;
}

zone 0.0.10.in-addr.arpa. {
  primary 10.0.0.9;
  key dns_update_key;
}

subnet 10.0.0.0 netmask 255.255.255.0 {
  range 10.0.0.100 10.0.0.200;
  option routers 10.0.0.1;
  option domain-name-servers 10.0.0.1;
  option interface-mtu 1420;
}
__EOF__

cat /etc/dhcp/dhcpd.conf

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
