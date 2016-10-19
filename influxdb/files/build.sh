#!/bin/sh

VERSION="%VERSION%"

GOPATH="/workspace"

export GOPATH

cd ${GOPATH} \
&& go get github.com/influxdata/influxdb \
&& cd ${GOPATH}/src/github.com/influxdata/influxdb \
&& git checkout v${VERSION} \
&& ./build.py \
&& mkdir /opt/influxdb-${VERSION} \
&& cp ./build/* /opt/influxdb-${VERSION}
