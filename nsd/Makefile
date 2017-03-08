TARGET = nsd
BUILD_DIR = ./build
FILES_DIR = ./files
SCRIPTS = ./scripts
SETTINGS = ./settings

VERSION = 4.1.9
ACI = ${TARGET}-${VERSION}-amd64.aci

CURL = curl -L -X PUT
ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd
ANYCAST_AGENT = ../scripts/anycast-agent
AACTL = ../scripts/aactl

ETCD_BASEDIR = /services/nsd

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${CONFD} ${BUILD_DIR}/confd
	install -o root -g root -m 0755 ${ANYCAST_AGENT} ${BUILD_DIR}/anycast-agent
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR} ${SETTINGS}/global
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/keys ${SETTINGS}/keys
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/zones ${SETTINGS}/zones
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${IP_NSD} \
		-d "value="  >/dev/null 2>&1
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${IP6_NSD} \
		-d "value=" >/dev/null 2>&1
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${NSD_ANYCAST_IPV4} \
		-d "value=" >/dev/null 2>&1
	${CURL} ${ETCD_ENDPOINTS}/v2/keys${ETCD_BASEDIR}/ip-address/${NSD_ANYCAST_IPV6} \
		-d "value=" >/dev/null 2>&1
	${AACTL} -apply ${FILES_DIR}/authdns.yml
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -d -o root -g root -m 0755 /var/rkt/nsd
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
