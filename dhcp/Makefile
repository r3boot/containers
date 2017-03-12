TARGET = dhcp
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
FILES_DIR = ./files
SCRIPTS = ./scripts
SETTINGS = ./settings
PACKAGES_DIR = ../packages

VERSION = 4.3.4
ACI = ${TARGET}-${VERSION}-amd64.aci

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd

ETCD_BASEDIR = /services/dhcp

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${CONFD} ${BUILD_DIR}/confd
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/global ${SETTINGS}/global
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/failover ${SETTINGS}/failover
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/hosts/dhcp-1.rkt ${SETTINGS}/dhcp-1.rkt
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/hosts/dhcp-2.rkt ${SETTINGS}/dhcp-2.rkt
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/subnets/10.42.14.0 ${SETTINGS}/10.42.14.0
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/subnets/10.42.15.0 ${SETTINGS}/10.42.15.0
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/interfaces/10.42.16.0 ${SETTINGS}/10.42.16.0
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/interfaces/10.42.17.0 ${SETTINGS}/10.42.17.0
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt/dhcp

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALLED_DIR} ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${TARGET} || true
