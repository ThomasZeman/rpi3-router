FROM wanbase:latest

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache iptables ip6tables bind-tools tcpdump dhclient

ADD runwan.sh /usr/sbin/runwan.sh

CMD ["/usr/sbin/runwan.sh"]

ENTRYPOINT ["/bin/sh"]
