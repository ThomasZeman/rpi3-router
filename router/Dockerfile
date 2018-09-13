FROM alpine:3.8

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache iptables ip6tables bind-tools tcpdump iproute2 \
    conntrack-tools ulogd python3 \
    && pip3 install --upgrade pip \
    && pip3 install flask gunicorn eventlet isc_dhcp_leases

COPY routeconfigurator /usr/sbin/routeconfigurator/
WORKDIR /usr/sbin/routeconfigurator

#RUN pip install -r requirements.txt

ADD runrouter.sh /usr/sbin/runrouter.sh

CMD ["/usr/sbin/runrouter.sh"]

ENTRYPOINT ["/bin/sh"]
