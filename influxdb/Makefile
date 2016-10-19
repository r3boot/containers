TARGET = influxdb
BUILD_DIR = ./build
INSTALL_DIR = ./installed
SCRIPTS = ./scripts

VERSION = 1.0.2
TARBALL = ${TARGET}-${VERSION}_linux_amd64.tar.gz
ACI = ${TARGET}-${VERSION}-amd64.aci
UPSTREAM = https://dl.influxdata.com/influxdb/releases
MD5SUM = 818346583d599428b1d8392fb6f003b4

all: fetch build_influxdb ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
  git clone https://github.com/influxdata/influxdb ${BUILD_DIR}/influxdb

build_influxdb:
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 files/build.sh \
		${BUILD_DIR}/build.sh
	sed -i -e "s,%VERSION%,${VERSION},g" ${BUILD_DIR}/build.sh
	rkt-builder
	cd ${INSTALL_DIR} && tar cvJf ../build/${TARGET}-${VERSION}-musl-amd64.tar.xz *

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image \
		${BUILD_DIR}/${TARGET}-${VERSION}-linux-amd64.aci
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt
	install -d -o root -g root -m 0750 /var/rkt/influxdb

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	rkt image rm ${TARGET} || true
