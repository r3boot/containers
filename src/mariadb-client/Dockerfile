FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add mariadb-client

COPY files/run_mariadb-client /run_mariadb-client

ENTRYPOINT ["/run_mariadb-client"]
CMD [""]
