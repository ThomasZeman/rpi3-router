#!/bin/sh

# trap signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

exec /usr/sbin/openvpn --config /data/client.ovpn

