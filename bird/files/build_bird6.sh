#!/bin/sh

VERSION='%VERSION%'

SRCDIR="/workspace/bird-${VERSION}"
DESTDIR="/opt/bird-${VERSION}"
SYMLINK="/opt/bird"

if [[ ! -d "${SRCDIR}" ]]; then
  echo "[E] ${SRCDIR} does not exist"
  exit 1
fi

cd ${SRCDIR} \
&& ./configure \
  --prefix=/opt/bird-${VERSION} \
  --sysconfdir=/etc/bird \
  --localstatedir=/var \
  --enable-ipv6 \
&& make -j 2 \
&& make install
