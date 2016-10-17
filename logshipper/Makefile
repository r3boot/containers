TARGET = logshipper
BUILD_DIR = ./build
INSTALL_DIR = ./installed
SCRIPTS = ./scripts

VERSION = latest
ACI = ${TARGET}-${VERSION}-amd64.aci

all: build ${ACI}

build:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -d ${INSTALL_DIR} ]] || mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 files/build.sh ${BUILD_DIR}/build.sh
	rkt-builder

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt/${TARGET}

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	rkt image rm ${TARGET} || true
