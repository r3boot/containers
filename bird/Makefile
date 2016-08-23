TARGET = bird
BUILD_DIR = ./build
INSTALL_DIR = ./installed
FILES = ./files
SCRIPTS = ./scripts
DATA_DIR = /var/rkt/bird
DATA_DIR6 = /var/rkt/bird6

VERSION = 1.6.0
TARBALL = ${TARGET}-${VERSION}.tar.gz
UPSTREAM = ftp://bird.network.cz/pub
SHA256 = db3dfe37deac73b38b7d6966e577985f7b8e23f246760cb095ad13b0d8010e13
ACI_BIRD = ${TARGET}-${VERSION}-amd64.aci
ACI_BIRD6 = ${TARGET}6-${VERSION}-amd64.aci

all: fetch verify extract build_bird build_bird6 ${ACI_BIRD} ${ACI_BIRD6}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -vp ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || \
		wget -O${BUILD_DIR}/${TARBALL} ${UPSTREAM}/${TARBALL}

verify:
	sha256sum ${BUILD_DIR}/${TARBALL} | grep ${SHA256}

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}/

build_bird:
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 ${FILES}/build_bird.sh \
		${BUILD_DIR}/build.sh
	sed -i -e "s,%VERSION%,${VERSION},g" ${BUILD_DIR}/build.sh
	rkt-builder
	cd ${INSTALL_DIR} && tar cvJf ../build/${TARGET}-${VERSION}-musl-amd64.tar.xz *
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true

build_bird6:
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 ${FILES}/build_bird6.sh \
		${BUILD_DIR}/build.sh
	sed -i -e "s,%VERSION%,${VERSION},g" ${BUILD_DIR}/build.sh
	rkt-builder
	cd ${INSTALL_DIR} && tar cvJf ../build/${TARGET}6-${VERSION}-musl-amd64.tar.xz *
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true

${ACI_BIRD}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci_bird.sh ${VERSION}

${ACI_BIRD6}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci_bird6.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI_BIRD}
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI_BIRD6}
	install -d -o root -g root -m 0750 ${DATA_DIR}
	install -d -o root -g root -m 0750 ${DATA_DIR}/config
	install -o root -g root -m 0640 ${FILES}/bird.conf \
		${DATA_DIR}/bird.conf
	install -d -o root -g root -m 0750 ${DATA_DIR6}
	install -d -o root -g root -m 0750 ${DATA_DIR6}/config
	install -o root -g root -m 0640 ${FILES}/bird6.conf \
		${DATA_DIR6}/bird6.conf

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	rkt image rm ${TARGET} || true
	rkt image rm ${TARGET}6 || true
