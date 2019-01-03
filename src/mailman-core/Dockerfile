FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add python3 postgresql-libs \
    && addgroup -S -g 810 mailman \
    && adduser -S -G mailman -u 810 mailman -s /bin/sh

COPY mailman-build/mailman-*.tar.xz /tmp
RUN tar xvJf /tmp/mailman-*.tar.xz && rm -f /tmp/mailman-*.tar.xz

COPY files/run_mailman-core /run_mailman-core

ENTRYPOINT ["/run_mailman-core"]
CMD [""]
