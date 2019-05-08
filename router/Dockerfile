FROM alpine:3.9.2

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache iptables ip6tables bind-tools tcpdump iproute2 \
    conntrack-tools ulogd python3 \
    && pip3 install --upgrade pip \
    && pip3 install flask isc_dhcp_leases

COPY routeconfigurator /usr/sbin/routeconfigurator/
WORKDIR /usr/sbin/routeconfigurator

ADD runrouter.sh /usr/sbin/runrouter.sh

CMD ["/usr/sbin/runrouter.sh"]

ENTRYPOINT ["/bin/sh"]
