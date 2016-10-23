#!/bin/sh

set -x

VERSION="%VERSION%"
GOPATH="/workspace"
export GOPATH

apk add nodejs \
&& cd ${GOPATH} \
&& (go get -v github.com/grafana/grafana || true) \
&& cd ${GOPATH}/src/github.com/grafana/grafana \
&& git checkout v${VERSION} \
&& go run build.go setup \
&& go run build.go build \
&& npm install \
&& npm run build \
&& mkdir -p /opt/grafana-${VERSION}/bin \
&& cp bin/grafana-server /opt/grafana-${VERSION}/bin/grafana-server \
&& cp bin/grafana-cli /opt/grafana-${VERSION}/bin/grafana-cli \
&& cp -Rp conf node_modules /opt/grafana-${VERSION}/ \
&& cp -Rp public_gen /opt/grafana-${VERSION}/public
