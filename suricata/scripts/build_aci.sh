#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

LIBMAGIC_PKG="libmagic-5.18-musl-amd64.tar.xz"
SURICATA_PKG="suricata-${VERSION}-musl-amd64.tar.xz"

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name suricata
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug copy build/run_suricata /usr/sbin/run_suricata
acbuild --debug copy build/${LIBMAGIC_PKG} /root/${LIBMAGIC_PKG}
acbuild --debug copy build/${SURICATA_PKG} /root/${SURICATA_PKG}
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add ca-certificates file geoip hiredis libnetfilter_log libnetfilter_queue libnftnl-libs iptables jansson libcap-ng libnet libpcap lua5.1-libs nspr sqlite-libs nss pcre wget xz yaml
acbuild --debug run -- tar xvJf /root/${LIBMAGIC_PKG} -C /
acbuild --debug run -- tar xvJf /root/${SURICATA_PKG} -C /
acbuild --debug copy build/suricata.yaml /etc/suricata/suricata.yaml
acbuild --debug set-exec /usr/sbin/run_suricata
acbuild --debug mount add logging /var/log/suricata
acbuild --debug write ./build/suricata-${VERSION}-amd64.aci
acbuild end
