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
    VAR_LIGHTTPD_CONF="printClause setup {}\\ninclude /etc/lighttpd2/mimetypes.conf;" \
    VAR_CLAUSE_SETUP="hej;\\nhej igen;"
     
ONBUILD USER root
