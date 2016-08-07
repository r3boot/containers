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
acbuild --debug set-name dbadmin
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add postgresql-client
acbuild --debug copy files/pgpass /root/.pgpass
acbuild --debug run -- chmod 0600 /root/.pgpass
acbuild --debug copy files/run_psql /usr/sbin/run_psql
acbuild --debug set-exec /usr/sbin/run_psql
acbuild --debug write ./build/dbadmin-${VERSION}-amd64.aci
acbuild end
