FROM alpine:3.9.2

LABEL maintainer="Thomas Zeman"

RUN apk update \
	&& apk --no-cache add dnsmasq

RUN echo -e "no-resolv\ndomain-needed\nno-resolv\nexpand-hosts\nserver=/lan/10.0.0.9\nrev-server=10.0.0.0/24,10.0.0.9\n" > /etc/dnsmasq.conf

ADD rundnsmasq.sh /usr/sbin/rundnsmasq.sh

CMD ["/usr/sbin/rundnsmasq.sh"]
