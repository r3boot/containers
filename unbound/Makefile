TARGET = unbound
BUILD_DIR = ./build
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 1.5.8
ACI = ${TARGET}-${VERSION}-amd64.aci

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
BASEDIR = /unbound

NUM_THREADS = 1
PORT = 53

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${ETCDCTL} ${BUILD_DIR}/etcdctl
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} /unbound ${SETTINGS}/global
	${SET_ETCD_SETTINGS} /unbound/access_control ${SETTINGS}/access_control
	${SET_ETCD_SETTINGS} /unbound/local_zone ${SETTINGS}/local_zone
	${SET_ETCD_SETTINGS} /unbound/local_data ${SETTINGS}/local_data
	${SET_ETCD_SETTINGS} /unbound/forward_zone ${SETTINGS}/forward_zone
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
