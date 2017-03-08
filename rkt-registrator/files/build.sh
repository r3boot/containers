#!/bin/sh

export GOPATH=/workspace
cd ${GOPATH}
go get -v github.com/r3boot/rkt-registrator
strip -v bin/rkt-registrator
stat bin/rkt-registrator
