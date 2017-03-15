TARGET = nginx-files
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
FILES_DIR = ./files
SCRIPTS = ./scripts
SETTINGS = ./settings
PACKAGES_DIR = ../packages

VERSION = 1.10.1
ACI = ${TARGET}-${VERSION}-amd64.aci

CURL = curl -L -X PUT
ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd

ETCD_BASEDIR = /services/nginx-files

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${CONFD} ${BUILD_DIR}/confd
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR} ${SETTINGS}/config
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt/files
	install -d -o root -g root -m 0755 /var/rkt/files/wwwroot
	install -d -o root -g root -m 0755 /var/rkt/files/logs

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALLED_DIR} ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${TARGET} || true
