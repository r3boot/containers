TARGET = etcd
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 3.0.4
TARBALL = ${TARGET}-v${VERSION}-linux-amd64.tar.gz
UPSTREAM = https://github.com/coreos/etcd/releases/download/v${VERSION}/${TARBALL}
ACI = ${TARGET}-${VERSION}-amd64.aci
METRICS_AGENT = etcd-metrics-to-influxdb
GPG_ID = F804F4137EF48FD3

all: fetch verify extract ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || \
		wget -O ${BUILD_DIR}/${TARBALL} ${UPSTREAM}
	[[ -f ${BUILD_DIR}/${TARBALL}.asc ]] || \
		wget -O ${BUILD_DIR}/${TARBALL}.asc ${UPSTREAM}.asc
	[[ -f ${BUILD_DIR}/${METRICS_AGENT} ]] || \
		install -o root -g root -m 0755 \
			../metrics-agents/installed/${METRICS_AGENT} \
			${BUILD_DIR}/${METRICS_AGENT}

verify:
	gpg --list-keys ${GPG_ID} || gpg --recv-keys ${GPG_ID}
	gpg --verify ${BUILD_DIR}/${TARBALL}.asc

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt
	install -d -o root -g root -m 0750 /var/rkt/etcd
	install -o root -g root -m 0755 ${BUILD_DIR}/etcd-v${VERSION}-linux-amd64/etcdctl \
		../scripts/etcdctl

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${ACI_NAME} || true
