FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add mariadb \
    && deluser mysql \
    && addgroup -S -g 814 mysql \
    && adduser -S -G mysql -u 814 mysql \
    && chown mysql:mysql /var/lib/mysql

COPY files/run_mariadb /run_mariadb

ENTRYPOINT ["/run_mariadb"]
CMD [""]
