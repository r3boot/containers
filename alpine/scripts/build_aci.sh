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
acbuild --debug set-name alpine
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug set-exec /bin/sh
acbuild --debug write ./build/alpine-${VERSION}-amd64.aci
acbuild end
