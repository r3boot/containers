TARGET = statsite
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 0.8.0
ACI = ${TARGET}-${VERSION}-amd64.aci
PKG = ${TARGET}-${VERSION}-musl-amd64.tar.xz

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
BASEDIR = /statsite

all: build_statsite ${ACI}

build_statsite:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -d ${INSTALLED_DIR} ]] || mkdir -p ${INSTALLED_DIR}
	install -o root -g root -m 0755 files/build.sh ${BUILD_DIR}/build.sh
	rkt-builder
	cd installed ; tar cvJf ../${BUILD_DIR}/${PKG} *

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${ETCDCTL} ${BUILD_DIR}/etcdctl
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${ETCDCTL} mkdir ${BASEDIR}
	${SET_ETCD_SETTINGS} ${BASEDIR}/influxdb ${SETTINGS}/influxdb
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALLED_DIR} ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${TARGET} || true
