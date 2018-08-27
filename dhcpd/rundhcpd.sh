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

exec /usr/sbin/dhcpd -d -cf /etc/dhcp/dhcpd.conf -lf /data/dhcpd.leases
