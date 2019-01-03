FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add openssl grep sed gawk bash \
    && wget -O/usr/bin/dehydrated \
    https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated \
    && chmod +x /usr/bin/dehydrated

COPY files/run_dehydrated /run_dehydrated

ENTRYPOINT ["/run_dehydrated"]
CMD [""]
