FROM alpine:3.7
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add redis \
    && deluser redis \
    && addgroup -S -g 804 redis \
    && adduser -S -G redis -u 804 redis

COPY files/run_redis-cli /run_redis-cli

ENTRYPOINT ["/run_redis-cli"]
CMD [""]
