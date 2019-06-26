#!/bin/sh

term_handler() {
        kill -TERM $sleepPid
        exit 143;
}

trap term_handler SIGTERM

sleep 10

dnsmasq -d

sleep 2147483647 &
sleepPid=$!
wait "$sleepPid"


