#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

PKG="statsite-${VERSION}-musl-amd64.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name statsite
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add bash python
acbuild --debug copy build/${PKG} /root/${PKG}
acbuild --debug run -- install -d -o root -g root -m 0755 /opt
acbuild --debug run -- tar xvJf /root/${PKG} -C /opt
acbuild --debug copy files/genconfig /usr/sbin/genconfig
acbuild --debug copy files/statsite.conf /etc/statsite/statsite.conf
acbuild --debug copy files/influxdb.ini /etc/statsite/influxdb.ini
acbuild --debug copy build/etcdctl /usr/bin/etcdctl
acbuild --debug copy files/run_statsite /usr/sbin/run_statsite
acbuild --debug set-exec /usr/sbin/run_statsite
acbuild --debug write ./build/statsite-${VERSION}-amd64.aci
acbuild end
