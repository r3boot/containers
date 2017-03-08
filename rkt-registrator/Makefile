TARGET = rkt-registrator
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
FILES_DIR = ./files
SCRIPTS = ./scripts

VERSION = latest
UPSTREAM = https://github.com/r3boot/${TARGET}
ACI = ${TARGET}-${VERSION}-amd64.aci

all: build ${ACI}

build:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -d ${INSTALLED_DIR} ]] || mkdir -p ${INSTALLED_DIR}
	install -o root -g root -m 0755 ${FILES_DIR}/build.sh ${BUILD_DIR}/build.sh
	rkt-builder

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/${TARGET}.service \
		/etc/systemd/system/${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt
	install -d -o root -g root -m 0750 /var/rkt/etcd

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALLED_DIR} ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${ACI_NAME} || true
