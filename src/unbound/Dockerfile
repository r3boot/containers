FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add unbound openssl bind-tools

COPY files/run_unbound /run_unbound
COPY files/unbound.conf /etc/unbound/unbound.conf

ENTRYPOINT ["/run_unbound"]
CMD [""]
