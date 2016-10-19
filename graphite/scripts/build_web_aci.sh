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
acbuild --debug set-name graphite-web
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy files/install_graphite_web.sh /root/install_graphite_web.sh
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- /root/install_graphite_web.sh
acbuild --debug run -- mkdir -p /etc/uwsgi
acbuild --debug run -- addgroup -S graphite
acbuild --debug run -- adduser -S -D -h /var/empty -g "Graphite user" -G graphite graphite
acbuild --debug copy files/graphite.ini /etc/uwsgi/graphite.ini
acbuild --debug copy files/graphite.wsgi /opt/graphite/conf/graphite.wsgi
acbuild --debug copy build/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
acbuild --debug copy files/run_graphite-web /usr/sbin/run_graphite-web
acbuild --debug mount add data /opt/graphite/storage
acbuild --debug set-exec /usr/sbin/run_graphite-web
acbuild --debug write ./build/graphite-web-${VERSION}-amd64.aci
acbuild end
