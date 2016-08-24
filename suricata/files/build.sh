#!/bin/sh

VERSION='%VERSION%'
LIBMAGIC_VERSION='%LIBMAGIC_VERSION%'

SRCDIR="/workspace/suricata-${VERSION}"
DESTDIR="/opt/suricata-${VERSION}"
SYMLINK="/opt/suricata"
TARBALL="/workspace/suricata-${VERSION}-musl-amd64.tar.xz"

LIBMAGIC_SRCDIR="/workspace/libmagic-${LIBMAGIC_VERSION}"
LIBMAGIC_DESTDIR="/opt/libmagic-${LIBMAGIC_VERSION}"
LIBMAGIC_SYMLINK="/opt/libmagic"
LIBMAGIC_TARBALL="/workspace/libmagic-${LIBMAGIC_VERSION}-musl-amd64.tar.xz"

if [[ ! -d "${LIBMAGIC_SRCDIR}" ]]; then
  echo "[E] ${LIBMAGIC_SRCDIR} does not exist"
  exit 1
fi

if [[ ! -d "${SRCDIR}" ]]; then
  echo "[E] ${SRCDIR} does not exist"
  exit 1
fi

# Add build dependencies
apk update
apk add pcre-dev yaml-dev libpcap-dev libcap-ng-dev iptables-dev nss-dev jansson-dev hiredis-dev lua-dev libnet-dev libnetfilter_queue-dev libnetfilter_log-dev geoip-dev xz wget

# Build libmagic
cd ${LIBMAGIC_SRCDIR} \
&& ./configure --prefix=${LIBMAGIC_DESTDIR} \
&& make -j2 \
&& make install \
&& ln -s ${LIBMAGIC_DESTDIR} ${LIBMAGIC_SYMLINK} \
&& tar cvJf ${LIBMAGIC_TARBALL} ${LIBMAGIC_DESTDIR} ${LIBMAGIC_SYMLINK}

# Build suricata
cd ${SRCDIR} \
&& ./configure \
  --prefix=/opt/suricata-3.1.1 \
  --sysconfdir=/etc \
  --localstatedir=/var \
  --enable-gccprotect \
  --with-libmagic-includes=/opt/libmagic/include \
  --with-libmagic-libraries=/opt/libmagic/lib \
  --enable-nflog \
  --enable-nfqueue \
  --enable-lua \
  --enable-geoip \
  --enable-hiredis \
&& make -j2 \
&& make install \
&& make install-conf \
&& ln -s /opt/suricata-${VERSION} /opt/suricata \
&& mkdir -p /etc/suricata/rules \
&& cp -Rp rules/*.rules /etc/suricata/rules/ \
&& tar cvJf ${TARBALL} ${DESTDIR} ${SYMLINK} /etc/suricata /var/log/suricata /var/run/suricata
