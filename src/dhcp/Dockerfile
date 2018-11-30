FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add dhcp bind-tools \
    && touch /var/lib/dhcp/dhcpd.leases

COPY files/run_dhcpd /run_dhcpd
COPY files/dhcpd.conf.tmpl /etc/dhcp/dhcpd.conf.tmpl

ENTRYPOINT ["/run_dhcpd"]
CMD [""]
