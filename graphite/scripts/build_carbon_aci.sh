#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

GITHUB='https://github.com/graphite-project'

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name graphite-carbon
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy files/install_graphite_carbon.sh /root/install_graphite_carbon.sh
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- /root/install_graphite_carbon.sh
acbuild --debug copy files/carbon.conf /opt/graphite/conf/carbon.conf
acbuild --debug copy files/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
acbuild --debug copy files/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
acbuild --debug run -- adduser -S -h /var/empty -g 'Carbon user' -D carbon
acbuild --debug mount add data /opt/graphite/storage
acbuild --debug set-exec -- /opt/graphite/bin/carbon-cache.py start --nodaemon
acbuild --debug write ./build/graphite-carbon-${VERSION}-amd64.aci
acbuild end
