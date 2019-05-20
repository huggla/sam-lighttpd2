ARG TAG="20190517"
ARG DESTDIR="/app"

FROM huggla/alpine as alpine

ARG BUILDDEPS="gcc g++ glib-dev make libtool automake autoconf libev-dev lua-dev ragel zlib-dev libressl-dev perl mailcap ssl_client"
ARG DOWNLOAD="https://git.lighttpd.net/lighttpd/lighttpd2.git/snapshot/lighttpd2-master.tar.gz"
ARG DESTDIR

RUN mkdir -p "$DESTDIR/run/fastcgi" "$DESTDIR/etc/lighttpd2" \
 && apk add $BUILDDEPS \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && wget $DOWNLOAD \
 && tar -xvp -f lighttpd2-master.tar.gz --strip-components 1 \
 && ./autogen.sh \
 && ./configure --prefix=/usr --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/include/lighttpd2 \
 && make \
 && make install \
 && mv contrib/default.html "$DESTDIR/default.html" \
 && mv contrib/*.conf "$DESTDIR/etc/lighttpd2/"
 
 FROM huggla/busybox:$TAG as image
 
 ARG DESTDIR
 
 COPY --from=alpine $DESTDIR $DESTDIR
