TARGET = postgresql
BUILD_DIR = ./build
SCRIPTS = ./scripts
SQL = ./sql

VERSION = 9.5.6
ACI = ${TARGET}-${VERSION}-amd64.aci
DBADMIN_ACI = dbadmin-${VERSION}-amd64.aci

all: ${ACI} ${DBADMIN_ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

${DBADMIN_ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_dbadmin_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	rkt fetch --insecure-options=image ${BUILD_DIR}/${DBADMIN_ACI}
	install -d -o root -g rkt -m 0750 /var/rkt/postgresql
	install -d -o root -g root -m 0755 /var/rkt/postgresql/data
	install -d -o root -g root -m 0755 /var/rkt/postgresql/sql
	install -o root -g root -m 0644 ${SQL}/*.sql /var/rkt/postgresql/sql
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
	rkt image rm dbadmin || true
