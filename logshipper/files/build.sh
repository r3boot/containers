#!/bin/sh

LOGSHIPPER='github.com/r3boot/logshipper'

TARGET='logshipper'
BUILD_DIR='./build'

apk update
apk add git go xz

mkdir -p /tmp/go
export GOPATH=/tmp/go

cd ${GOPATH} \
&& go get -v ${LOGSHIPPER} \
&& cd src/${LOGSHIPPER} \
&& mkdir ${BUILD_DIR} \
&& go build -v -o ${BUILD_DIR}/${TARGET} logshipper.go \
&& strip -v ${BUILD_DIR}/${TARGET} \
&& stat ${BUILD_DIR}/${TARGET} \
&& install -o root -g root -m 0755 ${BUILD_DIR}/${TARGET} /usr/sbin/${TARGET} \
&& install -o root -g root -m 0644 logshipper.yml /etc/logshipper.yml \
&& install -d -o root -g root -m 0755 /var/lib/logshipper \
&& tar cvJf /workspace/${TARGET}-latest-musl-amd64.tar.xz /usr/sbin/${TARGET} /etc/logshipper.yml /var/lib/logshipper
