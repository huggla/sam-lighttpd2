ARG TAG="20181113-edge"
ARG EXECUTABLES=/usr/sbin/lighttpd2

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base:$TAG} as base
FROM huggla/build as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_CONFIG_DIR="/etc/lighttpd2" \
    VAR_WWW_DIR="/var/www" \
    VAR_LINUX_USER="www-user" \
    VAR_MAX_OPEN_FILES="16384" \
    VAR_param_setup="module_load "mod_fastcgi", "mod_balance", "mod_deflate"; listen "0.0.0.0:80"; listen "[::]:80"; static.exclude_extensions [ ".php", ".pl", ".fcgi", "~", ".inc" ]"
     
ONBUILD USER root
