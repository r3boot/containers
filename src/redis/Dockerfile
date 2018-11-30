FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add redis \
    && deluser redis \
    && addgroup -S -g 804 redis \
    && adduser -S -G redis -u 804 redis

COPY files/run_redis /run_redis

ENTRYPOINT ["/run_redis"]
CMD [""]
