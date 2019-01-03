FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add dovecot dovecot-ldap \
    && deluser dovecot \
    && deluser dovenull \
    && addgroup -S -g 811 dovecot \
    && adduser -S -G dovecot -u 811 dovecot \
    && addgroup -S -g 812 dovenull \
    && adduser -S -G dovenull -u 812 dovenull

COPY files/run_dovecot /run_dovecot

ENTRYPOINT ["/run_dovecot"]
CMD [""]
