#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

INSTALL_DIR='etherpad-lite-1.6.1'
TARBALL="${INSTALL_DIR}.tar.gz"

# Generate machine id for this container
openssl rand -hex 16 > files/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name etherpad
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy files/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add wget ca-certificates nodejs-lts curl
acbuild --debug run -- wget -O/root/${TARBALL} https://github.com/ether/etherpad-lite/archive/1.6.1.tar.gz
acbuild --debug run -- mkdir -p /opt
acbuild --debug run -- tar xvzf /root/${TARBALL} -C /opt/
acbuild --debug run -- rm -f /root/${TARBALL}
acbuild --debug run -- /opt/${INSTALL_DIR}/bin/installDeps.sh
acbuild --debug run -- addgroup -S etherpad
acbuild --debug run -- adduser -S -G etherpad -s /bin/sh etherpad
acbuild --debug run -- chown -R etherpad:etherpad /opt/${INSTALL_DIR}
acbuild --debug copy files/settings.json /opt/${INSTALL_DIR}/settings.json
acbuild --debug copy files/run_etherpad /usr/sbin/run_etherpad
acbuild --debug port add client tcp 9001
acbuild --debug set-exec /usr/sbin/run_etherpad
acbuild --debug write --overwrite ./build/etherpad-${VERSION}-amd64.aci
acbuild end
