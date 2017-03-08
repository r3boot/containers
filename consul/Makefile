TARGET = consul
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 0.7.5
ZIPFILE = ${TARGET}_${VERSION}_linux_amd64.zip
UI_ZIPFILE = ${TARGET}_${VERSION}_web_ui.zip
HASHES = ${TARGET}_${VERSION}_SHA256SUMS
SIGNATURE = ${TARGET}_${VERSION}_SHA256SUMS.sig
ACI = ${TARGET}-${VERSION}-amd64.aci
UPSTREAM = https://releases.hashicorp.com/consul/${VERSION}
GPG_ID = 51852D87348FFC4C

EXPORTER_VERSION = 0.3.0
EXPORTER_TARBALL = consul_exporter-${EXPORTER_VERSION}.linux-amd64.tar.gz
EXPORTER_UPSTREAM_URL = https://github.com/prometheus/consul_exporter/releases/download/v${EXPORTER_VERSION}
EXPORTER_SHA256SUM = a7ee604d6c16fd096fff2f8f8d07da3a66c79b04b9135b8c71f0b9c79098e1ec


all: fetch verify extract ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}

	[[ -f ${BUILD_DIR}/${ZIPFILE} ]] || \
		wget -O${BUILD_DIR}/${ZIPFILE} ${UPSTREAM}/${ZIPFILE}

	[[ -f ${BUILD_DIR}/${UI_ZIPFILE} ]] || \
		wget -O${BUILD_DIR}/${UI_ZIPFILE} ${UPSTREAM}/${UI_ZIPFILE}

	[[ -f ${BUILD_DIR}/${HASHES} ]] || \
		wget -O${BUILD_DIR}/${HASHES} ${UPSTREAM}/${HASHES}

	[[ -f ${BUILD_DIR}/${SIGNATURE} ]] || \
		wget -O${BUILD_DIR}/${SIGNATURE} ${UPSTREAM}/${SIGNATURE}

	[[ -f ${BUILD_DIR}/${EXPORTER_TARBALL} ]] || \
		wget -O${BUILD_DIR}/${EXPORTER_TARBALL} \
		${EXPORTER_UPSTREAM_URL}/${EXPORTER_TARBALL}

verify:
	gpg --list-keys ${GPG_ID} || gpg --recv-keys ${GPG_ID}
	gpg --verify ${BUILD_DIR}/${SIGNATURE}
	sha256sum ${BUILD_DIR}/${EXPORTER_TARBALL} | grep ${EXPORTER_SHA256SUM}

extract:
	cd ${BUILD_DIR} ; unzip ${ZIPFILE}
	[[ -d ${BUILD_DIR}/ui ]] || mkdir -p ${BUILD_DIR}/ui
	cd ${BUILD_DIR}/ui ; unzip ../${UI_ZIPFILE}
	tar xvzf ${BUILD_DIR}/${EXPORTER_TARBALL} -C ${BUILD_DIR}/
	mv ${BUILD_DIR}/consul_exporter-${EXPORTER_VERSION}.linux-amd64/consul_exporter \
		${BUILD_DIR}/consul_exporter

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image \
		${BUILD_DIR}/${TARGET}-${VERSION}-linux-amd64.aci
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt
	install -d -o root -g root -m 0750 /var/rkt/consul

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
