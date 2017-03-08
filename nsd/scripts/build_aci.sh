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
acbuild --debug run -- install -d -o root -g nsd -m 0750 /srv/nsd
acbuild --debug run -- install -d -o root -g nsd -m 0750 /srv/nsd/zones
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/run
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/tmp
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/var
acbuild --debug run -- install -d -o root -g nsd -m 0770 /srv/nsd/log
acbuild --debug run -- rm -f /etc/nsd/nsd.conf.sample
acbuild --debug copy build/confd /usr/sbin/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/conf.d
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/templates
acbuild --debug copy files/confd.toml /etc/confd/confd.toml
acbuild --debug copy files/nsd.toml /etc/confd/conf.d/nsd.toml
acbuild --debug copy files/nsd.conf.tmpl /etc/confd/templates/nsd.conf.tmpl
acbuild --debug copy files/reload_nsd /usr/sbin/reload_nsd
acbuild --debug copy build/anycast-agent /usr/sbin/anycast-agent
acbuild --debug copy files/nsd.conf /etc/nsd/nsd.conf
acbuild --debug copy files/run_nsd /usr/sbin/run_nsd
acbuild --debug mount add zonefiles /srv/nsd/zones
acbuild --debug set-exec /usr/sbin/run_nsd
acbuild --debug write ./build/nsd-${VERSION}-amd64.aci
acbuild end
