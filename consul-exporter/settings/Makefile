TARGET = prometheus
BUILD_DIR = ./build
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 1.2.3
ACI = ${TARGET}-${VERSION}-amd64.aci
TARBALL = ${TARGET}-${VERSION}.linux-amd64.tar.gz
UPSTREAM_URL = https://github.com/prometheus/prometheus/releases/download/v${VERSION}
SHA256SUM = 8421a5f31a2e4721e945abb19c7831df7c461755120f9d467ef6bf07cc572305

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
BASEDIR = /nsd

all: fetch verify extract ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || wget \
		-O ${BUILD_DIR}/${TARBALL} ${UPSTREAM_URL}/${TARBALL}

verify:
	sha256sum ${BUILD_DIR}/${TARBALL} | grep -q ${SHA256SUM}

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${TARBALL}

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
