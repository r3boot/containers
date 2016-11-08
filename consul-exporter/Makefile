TARGET = consul-exporter
BUILD_DIR = ./build
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 0.2.0
ACI = ${TARGET}-${VERSION}-amd64.aci
TARBALL = consul_exporter-${VERSION}.linux-amd64.tar.gz
UPSTREAM_URL = https://github.com/prometheus/consul_exporter/releases/download/${VERSION}
SHA256SUM = 750d9f5aabb18f1b7e33ce46db9593ba69982a8bada90e96530bc7f31fd81934

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
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${ETCDCTL} ${BUILD_DIR}/etcdctl
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -d -o root -g root -m 0755 /var/rkt/${TARGET}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
