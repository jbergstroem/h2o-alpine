FROM alpine:3.11 as builder
MAINTAINER Johan Bergström <bugs@bergstroem.nu>

ARG BUILD_OPTIONS="-DCMAKE_INSTALL_SYSCONFDIR=/etc/h2o -DWITH_MRUBY=ON -DWITH_BUNDLED_SSL=OFF"
ARG VERSION="2.2.6"

WORKDIR /tmp/build

RUN apk add --no-cache build-base cmake zlib-dev openssl-dev libuv-dev wslay-dev bison ruby
RUN wget -q https://github.com/h2o/h2o/archive/v${VERSION}.tar.gz \
    && tar --strip 1 -xzf v${VERSION}.tar.gz \
    && cmake ${BUILD_OPTIONS} \
    && make -j $(nproc) \
    && strip h2o

FROM alpine:3.11 as h2o
COPY --from=builder /tmp/build/h2o /usr/local/bin/h2o
COPY --from=builder /usr/lib/libgcc*so* /usr/lib/libstdc*so* /usr/lib/
COPY h2o.conf /etc/h2o/h2o.conf
RUN apk add --no-cache wslay zlib tini
EXPOSE 80 443
ENTRYPOINT ["tini", "h2o"]
