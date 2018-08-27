#!/bin/sh

# trap signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP


while true; do sleep 86400; done
