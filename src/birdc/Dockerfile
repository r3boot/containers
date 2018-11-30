FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

COPY files/repositories /etc/apk/repositories

RUN apk update \
    && apk upgrade \
    && apk add bird

COPY files/run_birdc /run_birdc

ENTRYPOINT ["/run_birdc"]
CMD [""]
