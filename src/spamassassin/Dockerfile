FROM alpine:edge
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add spamassassin spamassassin-compiler \
    && addgroup -S -g 803 spamd \
    && adduser -S -G spamd -u 803 spamd

COPY files/run_spamd /run_spamd

ENTRYPOINT ["/run_spamd"]
CMD [""]
