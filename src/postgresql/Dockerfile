FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add postgresql

COPY files/run_postgresql /run_postgresql

ENTRYPOINT ["/run_postgresql"]
CMD [""]
