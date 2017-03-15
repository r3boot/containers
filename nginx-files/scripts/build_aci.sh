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
acbuild --debug set-name nginx-files
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add nginx
acbuild --debug run -- install -d -o root -g nginx -m 0750 /srv/wwwroot
acbuild --debug run -- install -d -o root -g nginx -m 0770 /srv/logs
acbuild --debug run -- install -d -o nginx -g nginx -m 0750 /var/lib/nginx/tmp
acbuild --debug run -- install -d -o nginx -g nginx -m 0750 /var/lib/nginx/tmp/client_body
acbuild --debug copy build/confd /usr/sbin/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/conf.d
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/templates
acbuild --debug copy files/confd.toml /etc/confd/confd.toml
acbuild --debug copy files/nginx.toml /etc/confd/conf.d/nginx.toml
acbuild --debug copy files/nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
acbuild --debug copy files/reload_nginx /usr/sbin/reload_nginx
acbuild --debug copy files/run_nginx /usr/sbin/run_nginx
acbuild --debug mount add data /srv/wwwroot
acbuild --debug mount add logs /srv/logs
acbuild --debug set-exec /usr/sbin/run_nginx
acbuild --debug write ./build/nginx-files-${VERSION}-amd64.aci
acbuild end
