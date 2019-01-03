#!/bin/sh

set -x

BASE_URL='https://ftp.exim.org/pub/exim/exim4/'
TARBALL="$(curl -s "${BASE_URL}" | grep 'xz\"' \
    | egrep -v 'html|pdf|postscript' | cut -d\" -f2)"
VERSION="$(echo "${TARBALL}" | sed -e 's,exim-,,g' -e 's,.tar.xz,,g')"

BUILD_DIR='/build'

cd ${BUILD_DIR}
echo "${VERSION}" > version.txt
wget ${BASE_URL}/${TARBALL}
tar xvJf exim-${VERSION}.tar.xz
ln -s exim-${VERSION} exim
mv /Makefile exim-${VERSION}/Local/Makefile
cd exim-${VERSION}
make makefile
make