FROM alpine:edge

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache tcpdump dnsmasq iptables ip6tables bind-tools dhclient -X http://dl-cdn.alpinelinux.org/alpine/edge/testing wireguard-tools wireguard-vanilla

ADD runwireguard.sh /usr/sbin/runwireguard.sh

#RUN sed -i '/exit 0/i  /usr/sbin/dnsmasq --conf-file=/etc/dnsmasq.conf\n' /etc/openvpn/up.sh
#RUN sed -i '/exit 0/i  killall dnsmasq\n' /etc/openvpn/down.sh

CMD ["/usr/sbin/runwireguard.sh"]

ENTRYPOINT ["/bin/sh"]
