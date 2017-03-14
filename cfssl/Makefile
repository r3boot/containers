TARGET = cfssl
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
SCRIPTS_DIR = ./scripts
SETTINGS = ./settings
GOPATH = $(shell readlink -f ${BUILD_DIR})

VERSION = latest
ACI = ${TARGET}-${VERSION}-amd64.aci
OCSP_ACI = ocsp-${VERSION}-amd64.aci

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd

ETCD_BASEDIR = /services/cfssl

all: build_glibc build_musl ${ACI} ${OCSP_ACI}

build_glibc:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p ${BUILD_DIR}
	GOPATH=${GOPATH} go get -v github.com/cloudflare/cfssl || true
	GOPATH=${GOPATH} go install -v github.com/cloudflare/cfssl/cmd/...
	strip -v ${BUILD_DIR}/bin/*
	mv -v ${BUILD_DIR}/bin ${BUILD_DIR}/bin-glibc
	rm -rf ${BUILD_DIR}/pkg ${BUILD_DIR}/src

build_musl:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p ${BUILD_DIR}
	[[ -d "${INSTALLED_DIR}" ]] || mkdir -p ${INSTALLED_DIR}
	install -o root -g root -m 0755 ./files/build.sh ${BUILD_DIR}/build.sh
	rkt-builder
	strip -v ${BUILD_DIR}/bin/*
	mv -v ${BUILD_DIR}/bin ${BUILD_DIR}/bin-musl

${ACI}:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS_DIR}/build_aci.sh ${VERSION}

${OCSP_ACI}:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS_DIR}/build_ocsp_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/ca-csr ${SETTINGS}/ca-csr
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/config ${SETTINGS}/config
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/database ${SETTINGS}/database
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/intermediary-csr ${SETTINGS}/intermediary-csr
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/ocsp-csr ${SETTINGS}/ocsp-csr
	[[ -d ../scripts/cfssl-glibc ]] || mkdir -p ../scripts/cfssl-glibc
	cp -Rp ${BUILD_DIR}/bin-glibc/* ../scripts/cfssl-glibc/
	[[ -d ../scripts/cfssl-musl ]] || mkdir -p ../scripts/cfssl-musl
	cp -Rp ${BUILD_DIR}/bin-musl/* ../scripts/cfssl-musl/
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	rkt fetch --insecure-options=image ${BUILD_DIR}/${OCSP_ACI}
	install -d -o root -g root -m 0750 /var/rkt/cfssl
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -o root -g root -m 0644 files/rkt-ocsp.service \
		/etc/systemd/system/rkt-ocsp.service
	install -o root -g root -m 0755 ${BUILD_DIR}/bin-glibc/cfssl \
		/usr/local/bin/cfssl
	install -o root -g root -m 0755 ${BUILD_DIR}/bin-glibc/cfssljson \
		/usr/local/bin/cfssljson
	install -d -o root -g root -m 0750 /etc/cfssl
	install -o root -g root -m 0644 files/db-config.json.tmpl \
		/etc/confd/templates/db-config.json.tmpl
	install -o root -g root -m 0644 files/db-config.toml \
		/etc/confd/conf.d/db-config.toml
	install -o root -g root -m 0644 files/ca-csr.json.tmpl \
		/etc/confd/templates/ca-csr.json.tmpl
	install -o root -g root -m 0644 files/ca-csr.toml \
		/etc/confd/conf.d/ca-csr.toml
	install -o root -g root -m 0644 files/intermediary-csr.json.tmpl \
		/etc/confd/templates/intermediary-csr.json.tmpl
	install -o root -g root -m 0644 files/intermediary-csr.toml \
		/etc/confd/conf.d/intermediary-csr.toml
	install -o root -g root -m 0644 files/ocsp-csr.json.tmpl \
		/etc/confd/templates/ocsp-csr.json.tmpl
	install -o root -g root -m 0644 files/ocsp-csr.toml \
		/etc/confd/conf.d/ocsp-csr.toml
	install -o root -g root -m 0644 files/cfssl-config.json.tmpl \
		/etc/confd/templates/cfssl-config.json.tmpl
	install -o root -g root -m 0644 files/cfssl-config.toml \
		/etc/confd/conf.d/cfssl-config.toml
	install -o root -g root -m 0755 files/cfssl_init_ca.sh \
		/usr/local/sbin/cfssl_init_ca.sh
	install -o root -g root -m 0755 files/cfssl_update_ocsp.sh \
		/usr/local/sbin/cfssl_update_ocsp.sh
	install -o root -g root -m 0755 files/cfssl_update_certs.sh \
		/usr/local/sbin/cfssl_update_certs.sh
	install -o root -g root -m 0755 files/cfssl_update_certs.sh \
		../scripts/cfssl_update_certs.sh

clean:
	[[ -d "${BUILD_DIR}" ]] && rm -rf ${BUILD_DIR} || true
	[[ -d "${INSTALLED_DIR}" ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${TARGET} || true
