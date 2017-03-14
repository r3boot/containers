TARGET = ldap
BUILD_DIR = ./build
INSTALLED_DIR = ./installed
FILES_DIR = ./files
SCRIPTS = ./scripts
SETTINGS = ./settings
PACKAGES_DIR = ../packages
CERTS_DIR = /etc/ssl/certs

VERSION = 2.4.44
ACI = ${TARGET}-${VERSION}-amd64.aci

ETCDCTL = ../scripts/etcdctl
SET_ETCD_SETTINGS = ../scripts/set-etcd-settings
CONFD = ../scripts/confd
CFSSL = ../scripts/cfssl-musl/cfssl
CFSSLJSON = ../scripts/cfssl-musl/cfssljson

ETCD_BASEDIR = /services/ldap

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0755 ${CONFD} ${BUILD_DIR}/confd
	install -o root -g root -m 0755 ${CFSSL} ${BUILD_DIR}/cfssl
	install -o root -g root -m 0755 ${CFSSLJSON} ${BUILD_DIR}/cfssljson
	install -o root -g root -m 0755 ${FILES_DIR}/update_certs \
		${BUILD_DIR}/update_certs
	install -o root -g root -m 0644 ${CERTS_DIR}/ca-bundle.pem \
		${BUILD_DIR}/ca-bundle.pem
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/global ${SETTINGS}/global
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/server ${SETTINGS}/server
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/db_config ${SETTINGS}/db_config
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/syncrepl ${SETTINGS}/syncrepl
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/peers/ldap-1.rkt ${SETTINGS}/ldap-1.rkt
	${SET_ETCD_SETTINGS} ${ETCD_BASEDIR}/peers/ldap-2.rkt ${SETTINGS}/ldap-2.rkt
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt/ldap

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALLED_DIR} ]] && rm -rf ${INSTALLED_DIR} || true
	rkt image rm ${TARGET} || true
