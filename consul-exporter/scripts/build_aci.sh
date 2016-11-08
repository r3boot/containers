#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

DIR="consul_exporter-${VERSION}.linux-amd64"
TARBALL="${DIR}.tar.gz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name consul-exporter
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug copy build/consul_exporter /usr/sbin/consul_exporter
acbuild --debug run -- addgroup -S consul
acbuild --debug run -- adduser -S -s /bin/sh -G consul -g 'Consul exporter user' -h /var/empty -D consul
acbuild --debug copy files/run_consul-exporter /usr/sbin/run_consul-exporter
acbuild --debug set-exec /usr/sbin/run_consul-exporter
acbuild --debug write ./build/consul-exporter-${VERSION}-amd64.aci
acbuild end
