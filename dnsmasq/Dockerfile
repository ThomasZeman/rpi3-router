FROM alpine:3.9.2

LABEL maintainer="Thomas Zeman"

RUN apk update \
	&& apk --no-cache add dnsmasq

RUN echo -e "no-resolv\ndomain-needed\nbogus-priv\nno-resolv\nexpand-hosts\ndomain=lan" > /etc/dnsmasq.conf

ADD rundnsmasq.sh /usr/sbin/rundnsmasq.sh

CMD ["/usr/sbin/rundnsmasq.sh"]
