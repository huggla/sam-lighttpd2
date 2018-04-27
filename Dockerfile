FROM huggla/alpine

ENV REV_CONFIG_DIR="/etc/lighttpd2"

RUN apk --no-cache add glib libev ragel lua zlib libbz2 openssl \
 && apk --no-cache add --virtual .build-dependencies gcc g++ glib-dev make libtool automake autoconf libev-dev lua-dev zlib-dev openssl-dev perl \
 && downloadDir="$(mktemp -d)" \
 && buildDir="$(mktemp -d)" \
 && wget https://git.lighttpd.net/lighttpd/lighttpd2.git/snapshot/lighttpd2-master.tar.gz -O "$downloadDir/lighttpd2-master.tar.gz" \
 && tar xfvz "$downloadDir/lighttpd2-master.tar.gz" -C "$buildDir" \
 && rm -rf "$downloadDir" \
 && cd "$buildDir/lighttpd2-master" \
# && ./autogen.sh \
# && ./configure --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/include/lighttpd-2.0.0 \
# && make \
# && make install \
 && perl contrib/create-mimetypes.conf.pl > "$REV_CONFIG_DIR/mimetypes.conf" \
 && cd / \
 && rm -rf "$buildDir" \
 && apk del .build-dependencies
 
ENV REV_LINUX_USER="www-user" \
    REV_angel_max_open_files="16384" \
    REV_lighttpd_setup="module_load "mod_fastcgi", "mod_balance", "mod_deflate"; listen "0.0.0.0:80"; listen "[::]:80"; static.exclude_extensions [ ".php", ".pl", ".fcgi", "~", ".inc" ]"
     
USER sudoer
