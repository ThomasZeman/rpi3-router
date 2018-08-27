FROM alpine:3.8

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache tcpdump dnsmasq

ADD dnsmasq.conf /etc/dnsmasq.conf
