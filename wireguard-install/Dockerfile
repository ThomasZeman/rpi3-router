FROM alpine:3.9.2
LABEL maintainer "Thomas Zeman"

RUN apk add --no-cache gcc make libc-dev libmnl-dev linux-rpi-dev

# https://git.zx2c4.com/WireGuard/refs/
ENV WIREGUARD_VERSION 0.0.20190227

RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		git \
	&& git clone --depth 1 --branch "${WIREGUARD_VERSION}" https://git.zx2c4.com/WireGuard.git /wireguard \
	&& ( \
		cd /wireguard/src \
		&& make tools \
		&& make -C tools install \
		&& make -C tools clean \
	) \
	&& apk del .build-deps

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "wg", "--help" ]
