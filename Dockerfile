FROM alpine:3.5
MAINTAINER Johan Bergström <bugs@bergstroem.nu>

ENV URL     https://github.com/h2o/h2o.git
ENV VERSION tags/v2.1.0
ENV BUILD_OPTIONS -DCMAKE_INSTALL_SYSCONFDIR=/etc/h2o -DWITH_MRUBY=off

RUN apk update \
    && apk upgrade \
    && apk add wslay libuv libstdc++ libgcc \
    && apk add --virtual .build-deps \
         build-base libressl-dev make wslay-dev libuv-dev \
         cmake git linux-headers zlib-dev \
    && git clone $URL h2o \
    && cd h2o \
    && git checkout $VERSION \
    && cmake $BUILD_OPTIONS \
    && make \
    && strip h2o \
    && cp h2o /usr/sbin \
    && cd .. \
    && rm -rf h2o \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && mkdir /etc/h2o

ADD h2o.conf /etc/h2o/
WORKDIR /etc/h2o/
EXPOSE 80 443
CMD h2o 
