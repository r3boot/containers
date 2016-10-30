#!/bin/sh

VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

# Generate machine id for this container
openssl rand -hex 16 > files/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name consul
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy files/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add ca-certificates
acbuild --debug run -- rm -f /var/cache/apk/*.gz
acbuild --debug copy files/telemetry.json /etc/consul/telemetry.json
acbuild --debug copy ./build/consul /usr/sbin/consul
acbuild --debug copy ./build/ui /var/www/consul
acbuild --debug mount add data /var/lib/consul
acbuild --debug port add tcp-8300 tcp 8300
acbuild --debug port add tcp-8301 tcp 8301
acbuild --debug port add udp-8301 udp 8301
acbuild --debug port add tcp-8302 tcp 8302
acbuild --debug port add udp-8302 udp 8302
acbuild --debug port add tcp-8400 tcp 8400
acbuild --debug port add tcp-8500 tcp 8500
acbuild --debug port add tcp-8600 tcp 8600
acbuild --debug port add udp-8600 udp 8600
acbuild --debug set-exec /usr/sbin/consul
acbuild --debug write ./build/consul-${VERSION}-linux-amd64.aci
acbuild end
