FROM huggla/alpine-slim as stage1

ARG APKS="glib libev ragel lua zlib libbz2 libressl2.7-libssl"

RUN apk --no-cache --root /rootfs add $APKS \
 && apk --no-cache add --virtual .build-dependencies gcc g++ glib-dev make libtool automake autoconf libev-dev lua-dev zlib-dev libressl-dev perl mailcap \
 && downloadDir="$(mktemp -d)" \
 && buildDir="$(mktemp -d)" \
 && wget https://git.lighttpd.net/lighttpd/lighttpd2.git/snapshot/lighttpd2-master.tar.gz -O "$downloadDir/lighttpd2-master.tar.gz" \
 && tar -xvpz --strip-components 1 -f "$downloadDir/lighttpd2-master.tar.gz" -C "$buildDir" \
 && rm -rf "$downloadDir" \
 && cd "$buildDir" \
 && ./autogen.sh \
 && ./configure --prefix=/usr/local --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/local/include/lighttpd-2.0.0 \
 && make \
 && make install \
 && mv /usr/local/sbin/lighttpd2 /usr/local/bin/ \
 && perl $buildDir/contrib/create-mimetypes.conf.pl > "/rootfs/mimetypes.conf" \
 && mv $buildDir/contrib/default.html "/rootfs/default.html" \
 && cd / \
 && rm -rf "$buildDir" \
 && cp -a /usr/local /rootfs/usr/ \
 && apk --no-cache del .build-dependencies

FROM huggla/base

ENV VAR_CONFIG_DIR="/etc/lighttpd2" \
    VAR_WWW_DIR="/var/www" \
    VAR_LINUX_USER="www-user" \
    VAR_angel_max_open_files="16384" \
    VAR_param_setup="module_load "mod_fastcgi", "mod_balance", "mod_deflate"; listen "0.0.0.0:80"; listen "[::]:80"; static.exclude_extensions [ ".php", ".pl", ".fcgi", "~", ".inc" ]"
     
ONBUILD USER root
