FROM alpine:3.8

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache hostapd tcpdump

ADD runhostapd.sh /usr/sbin/runhostapd.sh

CMD ["/usr/sbin/runhostapd.sh"]

ENTRYPOINT ["/bin/sh"]

