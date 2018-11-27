ARG TAG="20181113-edge"
ARG CONTENTIMAGE1="huggla/lighttpd2"
ARG CONTENTSOURCE1="/lighttpd2"
ARG CONTENTDESTINATION1="/"
ARG BASEIMAGE="huggla/base:test"
ARG BUILDIMAGE="huggla/build"
ARG EXECUTABLES="/usr/sbin/lighttpd2"

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base:$TAG} as base
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_CONFIG_DIR="/etc/lighttpd2" \
    VAR_WWW_DIR="/var/www" \
    VAR_LINUX_USER="www-user" \
    VAR_MAX_OPEN_FILES="16384" \
    VAR_param1_setup="\{ module_load [ \"mod_fastcgi\", \"mod_balance\", \"mod_deflate\" ]; listen \"0.0.0.0:80\"; listen \"[::]:80\"; static.exclude_extensions [ \".php\", \".pl\", \".fcgi\", \"~\", \".inc\" ]; \}" \
    VAR_param2_if="request.query=~\"(map|MAP)=\w+((\.|/)?\w)*(&.+)?\$\" { \
       balance.rr \{ fastcgi \"unix:/run/fastcgi/fastcgi.sock\"; \}; \
       if request.is_handled \{ \
          header.remove \"Content-Length\"; \
       \} \
    \} \
    else \{ \
       include \"/etc/lighttpd2/mimetypes.conf\"; \
       docroot \"\$VAR_WWW_DIR\"; \
       index [ \"index.php\", \"index.html\", \"index.htm\", \"default.htm\", \"index.lighttpd.html\" ]; \
       static; \
       if request.is_handled \{ \
          if response.header[\"Content-Type\"] =~ \"^(.*/javascript|text/.*)(;|\$)\" \{ \
             deflate; \
          \} \
       \} \
    \}"
     
#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
