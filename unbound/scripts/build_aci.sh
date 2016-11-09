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
acbuild --debug set-name unbound
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add unbound openssl curl
acbuild --debug copy build/etcdctl /usr/bin/etcdctl
acbuild --debug copy build/bin/unbound_exporter /usr/bin/unbound_exporter
acbuild --debug copy files/genconfig /usr/sbin/genconfig
acbuild --debug copy files/unbound.conf /etc/unbound/unbound.conf
acbuild --debug copy files/run_unbound /usr/sbin/run_unbound
acbuild --debug set-exec /usr/sbin/run_unbound
acbuild --debug write ./build/unbound-${VERSION}-amd64.aci
acbuild end
