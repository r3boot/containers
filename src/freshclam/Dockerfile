FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add freshclam clamav-libunrar \
    && deluser clamav \
    && addgroup -S -g 802 clamav \
    && adduser -S -G clamav -u 802 clamav

COPY files/run_freshclam /run_freshclam

ENTRYPOINT ["/run_freshclam"]
CMD [""]
