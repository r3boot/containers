FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add postgresql \
    && deluser postgres \
    && addgroup -S -g 806 postgres \
    && adduser -S -G postgres -u 806 postgres -s /bin/sh

COPY files/run_postgresql /run_postgresql

ENTRYPOINT ["/run_postgresql"]
CMD [""]
