TARGET = prometheus
BUILD_DIR = ./build
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 1.5.2
ACI = ${TARGET}-${VERSION}-amd64.aci
TARBALL = ${TARGET}-${VERSION}.linux-amd64.tar.gz
UPSTREAM_URL = https://github.com/prometheus/prometheus/releases/download/v${VERSION}
SHA256SUM = 971c5f365c3f53f52d05729acf43962905832b33d740798094850a25645de5ae

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd

ETCD_BASEDIR = /services/prometheus

all: fetch verify ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || wget \
		-O ${BUILD_DIR}/${TARBALL} ${UPSTREAM_URL}/${TARBALL}

verify:
	sha256sum ${BUILD_DIR}/${TARBALL} | grep -q ${SHA256SUM}

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${CONFD} ${BUILD_DIR}/confd
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR} ${SETTINGS}/global
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/jobs ${SETTINGS}/jobs
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -d -o root -g root -m 0755 /var/rkt/${TARGET}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
