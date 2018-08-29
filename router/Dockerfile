FROM alpine:3.8

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache iptables ip6tables bind-tools tcpdump

ADD runrouter.sh /usr/sbin/runrouter.sh

CMD ["/usr/sbin/runrouter.sh"]

ENTRYPOINT ["/bin/sh"]
