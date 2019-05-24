#!/bin/sh

docker build . -t rpi3-cloudflared --network=host
