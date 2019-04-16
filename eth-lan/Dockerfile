FROM alpine:3.9.2

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache tcpdump

ADD runethlan.sh /usr/sbin/runethlan.sh

CMD ["/usr/sbin/runethlan.sh"]

ENTRYPOINT ["/bin/sh"]

