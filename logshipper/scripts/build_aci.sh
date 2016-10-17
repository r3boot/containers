#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

PKG="logshipper-${VERSION}-musl-amd64.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name logshipper
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy build/${PKG} /root/${PKG}
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- tar xvJf /root/${PKG} -C /
acbuild --debug copy files/logshipper.yml /etc/logshipper.yml
acbuild --debug set-exec /usr/sbin/logshipper -- -D -f /etc/logshipper.yml
acbuild --debug mount add logs /logs
acbuild --debug mount add data /var/lib/logshipper
acbuild --debug write ./build/logshipper-${VERSION}-amd64.aci
acbuild end
