FROM alpine:latest AS builder
MAINTAINER Theo@keennews.nl


ENV SOCAT_VERSION 1.7.4.4


ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Get dependencies
RUN apk add --no-cache alpine-sdk

RUN set -x \
	&& mkdir /build \
	&& cd /build \
	&& curl -SL "http://www.dest-unreach.org/socat/download/socat-$SOCAT_VERSION.tar.gz" -o socat.tar.gz \
        && tar -zxph --strip-components=1 -f socat.tar.gz 


RUN set -x \
        && cd /build \
        && ./configure LDFLAGS=-static --disable-openssl \
        && make -j$(nproc)

FROM scratch
MAINTAINER Theo@keennews.nl
ENTRYPOINT ["/socat"]
USER 1000
COPY --from=builder --chown=1000 /build/socat /socat
