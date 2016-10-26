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
acbuild --debug set-name etcd
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy files/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug copy build/etcd-v${VERSION}-linux-amd64/etcdctl /usr/bin/etcdctl
acbuild --debug copy build/etcd-v${VERSION}-linux-amd64/etcd /usr/sbin/etcd
acbuild --debug copy build/etcd-metrics-to-influxdb /usr/bin/etcd-metrics-to-influxdb
acbuild --debug copy files/run_etcd /usr/sbin/run_etcd
acbuild --debug mount add data /var/lib/etcd
acbuild --debug port add client tcp 2379
acbuild --debug set-exec /usr/sbin/run_etcd
acbuild --debug write --overwrite ./build/etcd-${VERSION}-amd64.aci
acbuild end
