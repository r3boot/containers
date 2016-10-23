#!/bin/sh

VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

GRAFANA_PKG="grafana-${VERSION}-musl-amd64.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > files/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name grafana
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy files/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add ca-certificates
acbuild --debug run -- rm -f /var/cache/apk/*.gz
acbuild --debug copy build/${GRAFANA_PKG} /root/${GRAFANA_PKG}
acbuild --debug run -- mkdir -p /opt
acbuild --debug run -- tar xpJf /root/${GRAFANA_PKG} -C /opt/
acbuild --debug run -- ln -s /opt/grafana-${VERSION} /opt/grafana
acbuild --debug copy files/run_grafana /usr/sbin/run_grafana
acbuild --debug mount add data /opt/grafana/data
acbuild --debug set-exec /usr/sbin/run_grafana
acbuild --debug write ./build/grafana-${VERSION}-linux-amd64.aci
acbuild end
