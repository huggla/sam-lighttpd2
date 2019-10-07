# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.0"
ARG TAG="20191007"
ARG IMAGETYPE="application"
ARG RUNDEPS="glib libev lua libbz2"
ARG BUILDDEPS="libev-dev lua-dev ragel zlib-dev libressl-dev mailcap glib-dev"
ARG CLONEGITS="https://git.lighttpd.net/lighttpd/lighttpd2.git"
ARG STARTUPEXECUTABLES="/usr/sbin/lighttpd2"
ARG BUILDCMDS=\
"cd lighttpd2 "\
"&& ./autogen.sh "\
'&& eval "$COMMON_CONFIGURECMD --with-lua --with-openssl --with-kerberos5 --with-zlib --with-bzip2 --includedir=/usr/include/lighttpd2" '\
'&& eval "$COMMON_MAKECMDS" '\
'&& mv contrib/mimetypes.conf "$DESTDIR/" '\
'&& gzip "$DESTDIR/mimetypes.conf"'
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/build:$SaM_VERSION-$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_CONFIG_DIR="/etc/lighttpd2" \
    VAR_WWW_DIR="/var/www" \
    VAR_HTTP_SOCKET_FILE="/run/http/lighttpd.sock" \
    VAR_FASTCGI_SOCKET_FILE="/run/fastcgi/fastcgi.sock" \
    VAR_LINUX_USER="www-user" \
    VAR_FINAL_COMMAND="lighttpd2 -c '\$VAR_CONFIG_DIR/angel.conf'" \
    VAR_OPERATION_MODE="normal" \
    VAR_angel1_config="'\$VAR_CONFIG_DIR/lighttpd.conf'" \
    VAR_angel2_max_open_files="16384" \
    VAR_angel3_copy_env="[ 'PATH' ]" \
    VAR_angel4_allow_listen="'unix:\$VAR_HTTP_SOCKET_FILE'" \
    VAR_angel5_allow_listen="'0.0.0.0/0:4430'" \
    VAR_angel6_allow_listen="'0.0.0.0/0:8080'" \
    VAR_angel7_allow_listen="'unix:\$VAR_FASTCGI_SOCKET_FILE'" \
    VAR_setup1_module_load="[ 'mod_fastcgi', 'mod_balance' ]" \
    VAR_setup2_listen="'unix:\$VAR_HTTP_SOCKET_FILE'" \
    VAR_setup3_listen="'0.0.0.0:4430'" \
    VAR_setup4_listen="'0.0.0.0:8080'" \
    VAR_setup5_static__exclude_extensions="[ '.php', '.pl', '.fcgi', '~', '.inc' ]" \
    VAR_mode_fcgi=\
"      balance.rr { fastcgi 'unix:\$VAR_FASTCGI_SOCKET_FILE'; };\\\n"\
"      if request.is_handled { header.remove 'Content-Length'; }" \
    VAR_mode_normal=\
"      include '\$VAR_CONFIG_DIR/mimetypes.conf';\\\n"\
"      docroot '\$VAR_WWW_DIR';\\\n"\
"      index [ 'index.php', 'index.html', 'index.htm', 'default.htm', 'index.lighttpd.html' ];\\\n"\
"      static;\\\n"\
"      if request.is_handled {\\\n"\
"         if response.header['Content-Type'] =~ '^(.*/javascript|text/.*)(;|\$)' {\\\n"\
"            deflate;\\\n"\
"         }\\\n"\
"      }"
     
# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
