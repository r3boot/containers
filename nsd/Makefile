TARGET = nsd
BUILD_DIR = ./build
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 4.1.9
ACI = ${TARGET}-${VERSION}-amd64.aci

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
BASEDIR = /nsd

NUM_THREADS = 1
PORT = 53

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${ETCDCTL} ${BUILD_DIR}/etcdctl
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} /nsd ${SETTINGS}/global
	${SET_ETCD_SETTINGS} /nsd/keys ${SETTINGS}/keys
	${SET_ETCD_SETTINGS} /nsd/zones ${SETTINGS}/zones
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -d -o root -g root -m 0755 /var/rkt/nsd
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
