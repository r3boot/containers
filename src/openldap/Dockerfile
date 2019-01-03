FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add openldap openldap-backend-all openldap-overlay-all \
    && deluser ldap \
    && addgroup -S -g 808 ldap \
    && adduser -S -G ldap -u 808 ldap

COPY files/run_slapd /run_slapd

ENTRYPOINT ["/run_slapd"]
CMD [""]
