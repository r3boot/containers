#!/bin/sh

GOPATH='/workspace'
INSTALLED='/opt'
export GOPATH

cd ${GOPATH}
go get -v github.com/kelseyhightower/confd
strip -v bin/confd
stat bin/confd
