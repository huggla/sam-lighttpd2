ARG TAG="20181128"
ARG CONTENTIMAGE1="huggla/lighttpd2"
ARG CONTENTSOURCE1="/lighttpd2"
ARG CONTENTDESTINATION1="/"
ARG BASEIMAGE="huggla/base:test"
ARG EXECUTABLES="/usr/sbin/lighttpd2"
ARG REMOVEFILES="/etc/lighttpd2"

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_CONFIG_DIR="/etc/lighttpd2" \
    VAR_WWW_DIR="/var/www" \
    VAR_LINUX_USER="www-user" \
    VAR_FINAL_COMMAND="lighttpd2 -c \"\$VAR_CONFIG_DIR/angel.conf\"" \
    VAR_angel1_config="\"\$VAR_CONFIG_DIR/lighttpd.conf\";" \
    VAR_angel2_user="\"\$VAR_LINUX_USER\";" \
    VAR_angel3_max_open_files="16384;" \
    VAR_angel4_copy_env="[ \"PATH\" ];" \
    VAR_setup1_module_load="[ \"mod_fastcgi\", \"mod_balance\", \"mod_deflate\" ];" \
    VAR_setup2_listen="\"0.0.0.0:80\";" \
    VAR_setup3_listen="\"[::]:80\";"
#    VAR_setup4_static__exclude_extensions="[ \".php\", \".pl\", \".fcgi\", \"~\", \".inc\" ];" \
#    VAR_conf1_if="request.query=~\"(map|MAP)=\w+((\.|/)?\w)*(&.+)?\$\" { \\n\
#       balance.rr \{ fastcgi \"unix:/run/fastcgi/fastcgi.sock\"; \}; \
#       if request.is_handled \{ \
#          header.remove \"Content-Length\"; \
#       \} \
#    \} \
#    else \{ \
#       include \"/etc/lighttpd2/mimetypes.conf\"; \
#       docroot \"\$VAR_WWW_DIR\"; \
#       index [ \"index.php\", \"index.html\", \"index.htm\", \"default.htm\", \"index.lighttpd.html\" ]; \
#       static; \
#       if request.is_handled \{ \
#          if response.header[\"Content-Type\"] =~ \"^(.*/javascript|text/.*)(;|\$)\" \{ \
#             deflate; \
#          \} \
#       \} \
#    \}" \
     
#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
