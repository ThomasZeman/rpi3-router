FROM alpine:3.9.2

LABEL maintainer="Thomas Zeman (https://github.com/ThomasZeman)"

RUN apk add --no-cache bind

ADD runbind.sh /usr/sbin/runbind.sh
ADD db.10.0.0 /var/cache/bind/
ADD db.0.0.10.in-addr.arpa /var/cache/bind/

CMD ["/usr/sbin/runbind.sh"]

ENTRYPOINT ["/bin/sh"]
