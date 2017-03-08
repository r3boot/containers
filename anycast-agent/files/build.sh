#!/bin/sh

GOPATH='/workspace'
INSTALLED='/opt'
export GOPATH

cd ${GOPATH}
go get -v golang.org/x/net/context
go get -v gopkg.in/yaml.v2
go get -v github.com/coreos/etcd/client
go get -v github.com/r3boot/anycast-agent
cd src/github.com/r3boot/anycast-agent
make clean all
strip -v ./build/*
cp -p ./build/* ${INSTALLED}/
