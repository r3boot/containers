FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add nginx nginx-mod-http-fancyindex \
    && deluser nginx \
    && addgroup -S -g 43 tls \
    && addgroup -S -g 813 nginx \
    && adduser -S -G nginx -u 813 nginx \
    && addgroup nginx tls

COPY files/run_nginx /run_nginx

ENTRYPOINT ["/run_nginx"]
CMD [""]
