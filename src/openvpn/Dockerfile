FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add openvpn sudo \
    && deluser openvpn \
    && addgroup -S -g 805 openvpn \
    && adduser -S -G redis -u 805 openvpn

COPY files/run_openvpn /run_openvpn
COPY files/openvpn.sudoers /etc/sudoers.d/openvpn

VOLUME ["/etc/openvpn", "/var/run/openvpn", "/var/log/openvpn"]

ENTRYPOINT ["/run_openvpn"]
CMD [""]
