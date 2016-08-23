#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

BIRD_PKG="bird6-${VERSION}-musl-amd64.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

# Create userlist to be used from within the container
find ../*/files -name users.rabbitmq | xargs cat \
  | egrep -v '^#|^$' > build/userlist.txt

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name bird6
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy build/${BIRD_PKG} /root/${BIRD_PKG}
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add readline 
acbuild --debug run -- mkdir -p /opt
acbuild --debug run -- tar xpJf /root/${BIRD_PKG} -C /opt/
acbuild --debug run -- rm -f /root/${BIRD_PKG}
acbuild --debug write ./build/bird6-${VERSION}-amd64.aci
acbuild end
