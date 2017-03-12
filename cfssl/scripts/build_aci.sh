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
acbuild --debug set-name cfssl
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/cfssl
acbuild --debug copy build/bin-musl/cfssl /usr/sbin/cfssl
acbuild --debug copy build/bin-musl/goose /usr/sbin/goose
acbuild --debug copy files/run_cfssl /usr/sbin/run_cfssl
acbuild --debug mount add data /etc/cfssl
acbuild --debug set-exec /usr/sbin/run_cfssl
acbuild --debug write ./build/cfssl-${VERSION}-amd64.aci
acbuild end
