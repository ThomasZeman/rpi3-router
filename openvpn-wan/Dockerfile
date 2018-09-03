FROM base-wan:latest

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache openvpn

ADD runopenvpn.sh /usr/sbin/runopenvpn.sh

RUN sed -i '/exit 0/i  /usr/sbin/dnsmasq --conf-file=/etc/dnsmasq.conf\n' /etc/openvpn/up.sh
RUN sed -i '/exit 0/i  killall dnsmasq\n' /etc/openvpn/down.sh

CMD ["/usr/sbin/runopenvpn.sh"]

ENTRYPOINT ["/bin/sh"]
