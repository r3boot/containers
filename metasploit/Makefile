TARGET = metasploit
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 4.12.17
TARBALL = ${VERSION}.tar.gz
UPSTREAM = https://github.com/rapid7/metasploit-framework/archive
SHA1SUM = dfc395f253b4cac20a3c2263db4cf06922207434
ACI = ${TARGET}-${VERSION}-amd64.aci

INIT_SCRIPT = init.sh

all: fetch verify extract ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || \
		wget -O${BUILD_DIR}/${TARBALL} ${UPSTREAM}/${TARBALL}

verify:
	sha1sum ${BUILD_DIR}/${TARBALL} | grep -q ${SHA1SUM}

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}/

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
