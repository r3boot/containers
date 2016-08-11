#!/bin/sh

VERSION='%VERSION%'

SRCDIR="/workspace/otp-OTP-${VERSION}"
DESTDIR="/opt/erlang-${VERSION}"
SYMLINK="/opt/erlang"

if [[ ! -d "${SRCDIR}" ]]; then
  echo "[E] ${SRCDIR} does not exist"
  exit 1
fi

cd ${SRCDIR} \
&& ./otp_build setup -a \
  --enable-threads \
  --enable-smp-support \
  --enable-m64-build \
  --without-javac \
&& ./otp_build release -a ${DESTDIR} \
&& cd ${DESTDIR} \
&& ./Install ${DESTDIR} \
&& ln -s ${DESTDIR} ${SYMLINK} \
