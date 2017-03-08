TARGET = unbound
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
FILES_DIR = ./files
SCRIPTS = ./scripts
SETTINGS = ./settings
PACKAGES_DIR = ../packages

VERSION = 1.5.8
ACI = ${TARGET}-${VERSION}-amd64.aci

CURL = curl -L -X PUT
ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd
ANYCAST_AGENT = ../scripts/anycast-agent
AACTL = ../scripts/aactl

ETCD_BASEDIR = /services/unbound

all: build_exporter ${ACI}

build_exporter:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -d ${INSTALLED_DIR} ]] || mkdir -p ${INSTALLED_DIR}
	install -o root -g root -m 0755 files/build.sh ${BUILD_DIR}/build.sh
	rkt-builder

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${CONFD} ${BUILD_DIR}/confd
	install -o root -g root -m 0755 ${ANYCAST_AGENT} ${BUILD_DIR}/anycast-agent
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR} ${SETTINGS}/global
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/access_control ${SETTINGS}/access_control
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/forward_zone ${SETTINGS}/forward_zone
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${IP_UNBOUND} \
		-d "value="
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${IP6_UNBOUND} \
		-d "value="
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${UNBOUND_ANYCAST_IPV4} \
		-d "value="
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${UNBOUND_ANYCAST_IPV6} \
		-d "value="
	${AACTL} -apply ${FILES_DIR}/dns.yml
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALLED_DIR} ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${TARGET} || true
