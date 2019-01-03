FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add postgresql-client \
    && deluser postgres \
    && addgroup -S -g 806 postgres \
    && adduser -S -G postgres -u 806 postgres -s /bin/sh

COPY files/run_psql /run_psql

ENTRYPOINT ["/run_psql"]
CMD [""]
