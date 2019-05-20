ARG TAG="20190517"
ARG CONTENTIMAGE1="huggla/lighttpd2:$TAG"
ARG CONTENTSOURCE1="/app"
ARG RUNDEPS="glib libev lua libbz2"
ARG STARTUPEXECUTABLES="/usr/sbin/lighttpd2"
ARG REMOVEFILES="/etc/lighttpd2/angel.conf /etc/lighttpd2/lighttpd.conf"

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/}"
ARG CLONEGITSDIR
ARG DOWNLOADSDIR
ARG MAKEDIRS
ARG MAKEFILES
ARG EXECUTABLES
ARG STARTUPEXECUTABLES
ARG EXPOSEFUNCTIONS
ARG GID0WRITABLES
ARG GID0WRITABLESRECURSIVE
ARG LINUXUSEROWNED
ARG LINUXUSEROWNEDRECURSIVE
COPY --from=build /imagefs /
#---------------------------------------------

ENV VAR_CONFIG_DIR="/etc/lighttpd2" \
    VAR_WWW_DIR="/var/www" \
    VAR_HTTP_SOCKET_FILE="/run/http/lighttpd.sock" \
    VAR_FASTCGI_SOCKET_FILE="/run/fastcgi/fastcgi.sock" \
    VAR_LINUX_USER="www-user" \
    VAR_FINAL_COMMAND="lighttpd2 -c '\$VAR_CONFIG_DIR/angel.conf'" \
    VAR_angel1_config="'\$VAR_CONFIG_DIR/lighttpd.conf'" \
    VAR_angel2_max_open_files="16384" \
    VAR_angel3_copy_env="[ 'PATH' ]" \
    VAR_angel4_allow_listen="'unix:\$VAR_HTTP_SOCKET_FILE'" \
    VAR_angel5_allow_listen="'0.0.0.0/0:8080'" \
    VAR_angel6_allow_listen="'[::/0]:8080'" \
    VAR_angel7_allow_listen="'unix:\$VAR_FASTCGI_SOCKET_FILE'" \
    VAR_setup1_module_load="[ 'mod_fastcgi', 'mod_balance', 'mod_deflate' ]" \
    VAR_setup2_listen="'unix:\$VAR_HTTP_SOCKET_FILE'" \
    VAR_setup3_listen="'0.0.0.0:8080'" \
    VAR_setup4_listen="'[::]:8080'" \
    VAR_setup5_static__exclude_extensions="[ '.php', '.pl', '.fcgi', '~', '.inc' ]" \
    VAR_conf1_if="request.query=~'(map|MAP)=\\\w+((\.|/)?\\\w)*(&.+)?\$' {\\\n"\
"      balance.rr { fastcgi 'unix:\$VAR_FASTCGI_SOCKET_FILE'; };\\\n"\
"      if request.is_handled {\\\n"\
"         header.remove 'Content-Length';\\\n"\
"      }\\\n"\
"   }" \
    VAR_conf2_else="{\\\n"\
"      include '\$VAR_CONFIG_DIR/mimetypes.conf';\\\n"\
"      docroot '\$VAR_WWW_DIR';\\\n"\
"      index [ 'index.php', 'index.html', 'index.htm', 'default.htm', 'index.lighttpd.html' ];\\\n"\
"      static;\\\n"\
"      if request.is_handled {\\\n"\
"         if response.header['Content-Type'] =~ '^(.*/javascript|text/.*)(;|\$)' {\\\n"\
"            deflate;\\\n"\
"         }\\\n"\
"      }\\\n"\
"   }"
     
#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------
