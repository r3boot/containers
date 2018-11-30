FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

COPY files/repositories /etc/apk/repositories

RUN apk update \
    && apk upgrade \
    && apk add bird \
    && addgroup -S -g 800 bird \
    && adduser -S -G bird -u 800 bird

COPY files/run_bird /run_bird

ENTRYPOINT ["/run_bird"]
CMD [""]
