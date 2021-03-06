#!/bin/sh

ip route del default

ip route add 10.0.0.0/24 via 10.1.1.1
ip route add default via 10.1.0.100

term_handler() {
        kill -TERM $sleepPid
        exit 143;
}

trap term_handler SIGTERM

sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"


