FROM alpine:3.8

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache dhcp tcpdump

ADD rundhcpd.sh /usr/sbin/rundhcpd.sh

CMD ["/usr/sbin/rundhcpd.sh"]

ENTRYPOINT ["/bin/sh"]
