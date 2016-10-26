#!/bin/sh

GOPATH='/workspace'
INSTALLED='/opt'
export GOPATH

cd ${GOPATH}
go get -v github.com/r3boot/rlib
cd src
make
cp -p ./build/* ${INSTALLED}/
