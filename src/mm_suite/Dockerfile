FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add python3 postgresql-libs py3-psycopg2 \
    && addgroup -S -g 810 mailman \
    && adduser -S -G mailman -u 810 mailman -s /bin/sh

COPY mm_suite-build/mm_suite-*.tar.xz /tmp
RUN tar xvJf /tmp/mm_suite-*.tar.xz && rm -f /tmp/mm_suite-*.tar.xz

COPY files/run_mm_suite /run_mm_suite

ENTRYPOINT ["/run_mm_suite"]
CMD [""]
