TARGET = grafana
BUILD_DIR = ./build
INSTALL_DIR = ./installed
SCRIPTS = ./scripts

VERSION = 3.1.1
ACI = ${TARGET}-${VERSION}-amd64.aci

all: build_grafana ${ACI}

build_grafana:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 files/build.sh \
		${BUILD_DIR}/build.sh
	sed -i -e "s,%VERSION%,${VERSION},g" ${BUILD_DIR}/build.sh
	rkt-builder
	rm -f ${INSTALL_DIR}/grafana-3.1.1/node_modules/phantomjs-prebuilt/lib/phantom/bin/phantomjs || true
	cd ${INSTALL_DIR} && tar cvJf ../build/${TARGET}-${VERSION}-musl-amd64.tar.xz *

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image \
		${BUILD_DIR}/${TARGET}-${VERSION}-linux-amd64.aci
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0750 /var/rkt/grafana

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	rkt image rm ${TARGET} || true
