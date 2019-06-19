#!/bin/sh

cat /data/dns_update_key > /etc/bind/named.conf.local

cat >> /etc/bind/named.conf.local << '__EOF__'

controls { };

options {
    recursion no;
    additional-from-auth no;
    additional-from-cache no;
};

zone "lan" {
  type master;
  notify no;
  file "/var/cache/bind/db.10.0.0";
  allow-update { key dns_update_key; };
};

zone "0.0.10.in-addr.arpa" {
  type master;
  notify no;
  file "/var/cache/bind/db.0.0.10.in-addr.arpa";
  allow-update { key dns_update_key; };
};

__EOF__

cat /etc/bind/named.conf.local

/usr/sbin/named -c /etc/bind/named.conf.local

dhcpdPid=$(ps auxw | grep /bind | grep -v grep | awk '{print $1}')

term_handler() {
        kill -SIGTERM $dhcpdPid
        kill -TERM $sleepPid
}

trap term_handler SIGTERM

echo "Waiting for SIGTERM"
sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"
