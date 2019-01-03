FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add php7-fpm php7-mysqli php7-mysqlnd php7-curl php7-gd php7-mbstring \
        php7-xml php7-xmlrpc php7-soap php7-intl php7-zip \
    && addgroup -S -g 813 nginx \
    && addgroup -S -g 815 wp_spiderwebz \
    && adduser -S -G wp_spiderwebz -u 815 wp_spiderwebz

COPY files/run_wordpress /run_wordpress

ENTRYPOINT ["/run_wordpress"]
CMD [""]
