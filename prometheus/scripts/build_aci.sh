#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

DIR="prometheus-${VERSION}.linux-amd64"
TARBALL="${DIR}.tar.gz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name prometheus
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug copy build/${TARBALL} /root/${TARBALL}
acbuild --debug run -- install -d -o root -g root -m 0755 /opt
acbuild --debug run -- tar xvzf /root/${TARBALL} -C /opt
acbuild --debug run -- ln -s /opt/${DIR} /opt/prometheus
acbuild --debug run -- rm -f /root/${TARBALL}
acbuild --debug run -- addgroup -S prometheus
acbuild --debug run -- adduser -S -s /sbin/nologin -G prometheus -g 'Prometheus user' -h /opt/prometheus -D prometheus
acbuild --debug copy files/prometheus.yml /opt/${DIR}/prometheus.yml
acbuild --debug copy build/confd /usr/sbin/confd
acbuild --debug run -- install -d -o root -g root -m 0755 /etc/confd
acbuild --debug run -- install -d -o root -g root -m 0755 /etc/confd/conf.d
acbuild --debug run -- install -d -o root -g root -m 0755 /etc/confd/templates
acbuild --debug copy files/confd.toml /etc/confd/confd.toml
acbuild --debug copy files/prometheus.toml /etc/confd/conf.d/prometheus.toml
acbuild --debug copy files/prometheus.yml.tmpl /etc/confd/templates/prometheus.yml.tmpl
acbuild --debug copy files/run_prometheus /usr/sbin/run_prometheus
acbuild --debug mount add data /opt/prometheus/data
acbuild --debug set-exec /usr/sbin/run_prometheus
acbuild --debug write ./build/prometheus-${VERSION}-amd64.aci
acbuild end
