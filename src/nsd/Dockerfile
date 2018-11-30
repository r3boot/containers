FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add nsd openssl \
    && deluser nsd \
    && addgroup -S -g 801 nsd \
    && adduser -S -G nsd -u 801 nsd

COPY files/run_nsd /run_nsd

ENTRYPOINT ["/run_nsd"]
CMD [""]
