FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN addgroup -S -g 807 cfssl \
    && adduser -S -G cfssl -u 807 cfssl -s /bin/sh


COPY go/x86_64/musl/bin/cfssl /usr/sbin/cfssl
COPY files/run_cfssl /run_cfssl

ENTRYPOINT ["/run_cfssl"]
CMD [""]
