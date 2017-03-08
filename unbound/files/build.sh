#!/bin/sh

export GOPATH=/workspace
cd ${GOPATH}
go get -v github.com/r3boot/unbound_exporter
strip -v bin/unbound_exporter
stat bin/unbound_exporter
