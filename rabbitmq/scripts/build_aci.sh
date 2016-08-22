#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

ERL_VERSION='19.0'
ERL_PKG="erlang-${ERL_VERSION}-linux-amd64.tar.xz"
RABBITMQ_PKG="rabbitmq-server-generic-unix-${VERSION}.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

# Create userlist to be used from within the container
find ../*/files -name users.rabbitmq | xargs cat \
  | egrep -v '^#|^$' > build/userlist.txt

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name rabbitmq
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy build/userlist.txt /root/userlist.txt
acbuild --debug copy files/setup_users /root/setup_users
acbuild --debug copy files/run_rabbitmq /usr/sbin/run_rabbitmq
acbuild --debug copy build/${ERL_PKG} /root/${ERL_PKG}
acbuild --debug copy build/${RABBITMQ_PKG} /root/${RABBITMQ_PKG}
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add ncurses
acbuild --debug run -- mkdir -p /opt
acbuild --debug run -- tar xpJf /root/${ERL_PKG} -C /opt/
acbuild --debug run -- tar xpJf /root/${RABBITMQ_PKG} -C /opt/
acbuild --debug run -- ln -s /opt/rabbitmq_server-${VERSION} /opt/rabbitmq
acbuild --debug run -- /root/setup_users
acbuild --debug run -- rm -f /root/${ERL_PKG} /root/${RABBITMQ_PKG} /root/setup_users /root/userlist.txt
acbuild --debug set-exec /usr/sbin/run_rabbitmq
acbuild --debug write ./build/rabbitmq-${VERSION}-amd64.aci
acbuild end
