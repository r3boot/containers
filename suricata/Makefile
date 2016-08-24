TARGET = suricata
BUILD_DIR = ./build
INSTALL_DIR = ./installed
SCRIPTS = ./scripts

VERSION = 3.1.1
TARBALL = ${TARGET}-${VERSION}.tar.gz
SIGNATURE = ${TARGET}-${VERSION}.tar.gz.sig
UPSTREAM = http://www.openinfosecfoundation.org/download
GPG_ID = 00C1B70D

LIBMAGIC_VERSION = 5.18
LIBMAGIC_TARBALL = ${LIBMAGIC_VERSION}.tar.gz
LIBMAGIC_UPSTREAM = https://github.com/threatstack/libmagic/archive
LIBMAGIC_SHA256SUM = a6ae87df22becb60793e6f8a06e280f3d528fad4aa15d6389a7ec088be664492

ACI = ${TARGET}-${VERSION}-amd64.aci

INTERFACE = eth0
HOME_NET = 192.168.0.0/24

all: fetch verify extract build_suricata ${ACI}

envcheck:
	export | grep INTERFACE
	export | grep HOME_NET

fetch:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p "${BUILD_DIR}"
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || \
		wget -O${BUILD_DIR}/${TARBALL} ${UPSTREAM}/${TARBALL}
	[[ -f ${BUILD_DIR}/${SIGNATURE} ]] || \
		wget -O${BUILD_DIR}/${SIGNATURE} ${UPSTREAM}/${SIGNATURE}
	[[ -f ${BUILD_DIR}/${LIBMAGIC_TARBALL} ]] || \
		wget -O${BUILD_DIR}/${LIBMAGIC_TARBALL} ${LIBMAGIC_UPSTREAM}/${LIBMAGIC_TARBALL}

verify:
	gpg --list-keys ${GPG_ID} || gpg --recv-keys 00C1B70D
	gpg --verify ${BUILD_DIR}/${SIGNATURE}
	sha256sum ${BUILD_DIR}/${LIBMAGIC_TARBALL} | grep ${LIBMAGIC_SHA256SUM}

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}/
	tar xvzf ${BUILD_DIR}/${LIBMAGIC_TARBALL} -C ${BUILD_DIR}/

build_suricata:
	[[ -d ${INSTALL_DIR} ]] || mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 files/build.sh ${BUILD_DIR}/build.sh
	sed -i \
		-e "s,%VERSION%,${VERSION},g" \
		-e "s,%LIBMAGIC_VERSION%,${LIBMAGIC_VERSION},g" \
		${BUILD_DIR}/build.sh
	rkt-builder
	install -o root -g root -m 0755 files/run_suricata \
		${BUILD_DIR}/run_suricata
	sed -i \
		-e "s,%VERSION%,${VERSION},g" \
		-e "s,%LIBMAGIC_VERSION%,${LIBMAGIC_VERSION},g" \
		-e "s,%INTERFACE%,${INTERFACE},g" \
		${BUILD_DIR}/run_suricata
	install -o root -g root -m 0644 files/suricata.yaml \
		${BUILD_DIR}/suricata.yaml
	sed -i \
		-e "s,%HOME_NET%,${HOME_NET},g" \
		${BUILD_DIR}/suricata.yaml
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		${BUILD_DIR}/rkt-${TARGET}.service
	sed -i \
		-e "s,%INTERFACE%,${INTERFACE},g" \
		${BUILD_DIR}/rkt-${TARGET}.service

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 ${BUILD_DIR}/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/log/rkt/${TARGET}

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	rkt image rm ${TARGET} || true
