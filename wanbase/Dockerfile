FROM alpine:3.8

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache tcpdump dnsmasq iptables ip6tables bind-tools dhclient

ADD dnsmasq.conf /etc/dnsmasq.conf
