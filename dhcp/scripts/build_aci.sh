#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name dhcp
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add dhcp
acbuild --debug copy build/confd /usr/sbin/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/conf.d
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/templates
acbuild --debug copy files/confd.toml /etc/confd/confd.toml
acbuild --debug copy files/dhcpd.toml /etc/confd/conf.d/dhcpd.toml
acbuild --debug copy files/dhcpd.conf.tmpl /etc/confd/templates/dhcpd.conf.tmpl
acbuild --debug copy files/run_dhcpd /usr/sbin/run_dhcpd
acbuild --debug mount add data /var/lib/dhcp
acbuild --debug set-exec /usr/sbin/run_dhcpd
acbuild --debug write ./build/dhcp-${VERSION}-amd64.aci
acbuild end
