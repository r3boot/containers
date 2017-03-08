#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

# Generate machine id for this container
openssl rand -hex 16 > files/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name rkt-registrator
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy files/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug copy build/bin/rkt-registrator /usr/sbin/rkt-registrator
acbuild --debug mount add cni /var/lib/cni
acbuild --debug mount add rkt /var/lib/rkt
acbuild --debug set-exec /usr/sbin/rkt-registrator
acbuild --debug write --overwrite ./build/rkt-registrator-${VERSION}-amd64.aci
acbuild end
