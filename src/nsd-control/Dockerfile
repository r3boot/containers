FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add nsd

COPY files/run_nsd-control /run_nsd-control

ENTRYPOINT ["/run_nsd-control"]
CMD [""]
