#!/bin/sh

GOPATH='/workspace'
INSTALLED='/opt'
export GOPATH

cd ${GOPATH}
go get -v github.com/GeertJohan/go.rice
go get -v github.com/GeertJohan/go.rice/rice
go get -v bitbucket.org/liamstask/goose/cmd/goose
go get -v github.com/cloudflare/cfssl
cd ${GOPATH}/src/github.com/cloudflare/cfssl/cli/serve
${GOPATH}/bin/rice embed-go
cd ${GOPATH}
go install -v github.com/cloudflare/cfssl/cmd/...

