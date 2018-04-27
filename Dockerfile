FROM huggla/alpine

ENV BEV_CONFIG_DIR="/etc/lighttpd2" \
    BEV_WWW_DIR="/var/www"

RUN apk --no-cache add glib libev ragel lua zlib libbz2 openssl \
 && apk --no-cache add --virtual .build-dependencies gcc g++ glib-dev make libtool automake autoconf libev-dev lua-dev zlib-dev openssl-dev perl mailcap \
 && downloadDir="$(mktemp -d)" \
 && buildDir="/tmp/build" \
 && wget https://git.lighttpd.net/lighttpd/lighttpd2.git/snapshot/lighttpd2-master.tar.gz -O "$downloadDir/lighttpd2-master.tar.gz" \
 && tar xfvz "$downloadDir/lighttpd2-master.tar.gz" -C "$buildDir" \
 && rm -rf "$downloadDir" \
 && cd "$buildDir/lighttpd2-master" \
 && ./autogen.sh \
 && ./configure --help \
 && ./configure --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/include/lighttpd-2.0.0 \
 && make \
 && make install \
 && mv /usr/local/sbin/lighttpd2 "$BIN_DIR/lighttpd2" \
 && mkdir -p "$BEV_CONFIG_DIR" \
 && perl contrib/create-mimetypes.conf.pl > "$BEV_CONFIG_DIR/mimetypes.conf" \
 && mv contrib/default.html "$BEV_WWW_DIR/default.html" \
 && cd / \
# && rm -rf "$buildDir" \
 && apk del .build-dependencies
 
ENV REV_LINUX_USER="www-user" \
    REV_angel_max_open_files="16384" \
    REV_config_001_setup="module_load "mod_fastcgi", "mod_balance", "mod_deflate"; listen "0.0.0.0:80"; listen "[::]:80"; static.exclude_extensions [ ".php", ".pl", ".fcgi", "~", ".inc" ]"
     
USER sudoer
