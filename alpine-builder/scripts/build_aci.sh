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
acbuild --debug set-name alpine-builder
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy files/run_build.sh /usr/bin/run_build.sh
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add autoconf automake gcc g++ clang perl bison m4 make flex
acbuild --debug run -- apk add ncurses-dev openssl-dev
acbuild --debug mount add workspace /workspace
acbuild --debug mount add install /opt
acbuild --debug set-exec /usr/bin/run_build.sh
acbuild --debug write ./build/alpine-builder-${VERSION}-amd64.aci
acbuild end
