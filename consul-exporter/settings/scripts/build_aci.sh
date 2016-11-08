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
acbuild --debug set-name nsd
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add nsd openssl curl
acbuild --debug run -- addgroup -S nsd
acbuild --debug run -- adduser -S -s /sbin/nologin -G nsd -g 'NSD user' -h /srv/nsd -D nsd
acbuild --debug run -- install -d -o root -g nsd -m 0750 /srv/nsd
acbuild --debug run -- install -d -o root -g nsd -m 0750 /srv/nsd/zones
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/run
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/tmp
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/var
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/log
acbuild --debug run -- rm -f /etc/nsd/nsd.conf.sample
acbuild --debug copy build/etcdctl /usr/bin/etcdctl
acbuild --debug copy files/genconfig /usr/sbin/genconfig
acbuild --debug copy files/nsd.conf /etc/nsd/nsd.conf
acbuild --debug copy files/gather_metrics /usr/sbin/gather_metrics
acbuild --debug copy files/run_nsd /usr/sbin/run_nsd
acbuild --debug mount add zonefiles /srv/nsd/zones
acbuild --debug set-exec /usr/sbin/run_nsd
acbuild --debug write ./build/nsd-${VERSION}-amd64.aci
acbuild end
