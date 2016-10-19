#!/bin/sh

VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

INFLUXDB_PKG="influxdb-${VERSION}-musl-amd64.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > files/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name influxdb
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy files/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- rm -f /var/cache/apk/*.gz
acbuild --debug copy build/${INFLUXDB_PKG} /root/${INFLUXDB_PKG}
acbuild --debug run -- mkdir -p /opt /etc/influxdb
acbuild --debug run -- tar xpJf /root/${INFLUXDB_PKG} -C /opt/
acbuild --debug run -- ln -s /opt/influxdb-${VERSION} /opt/influxdb
acbuild --debug copy files/influxdb.conf /etc/influxdb/influxdb.conf
acbuild --debug mount add data /var/lib/influxdb
acbuild --debug set-exec /opt/influxdb/influxd run
acbuild --debug write ./build/influxdb-${VERSION}-linux-amd64.aci
acbuild end
