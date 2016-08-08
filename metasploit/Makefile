TARGET = metasploit
BUILD_DIR = ./build
SCRIPTS = ./scripts
PG_SCRIPTS = ../postgresql/scripts

VERSION = 4.12.17
TARBALL = ${VERSION}.tar.gz
UPSTREAM = https://github.com/rapid7/metasploit-framework/archive
CHECK_URL = https://github.com/rapid7/metasploit-framework/releases
SHA1SUM = dfc395f253b4cac20a3c2263db4cf06922207434
ACI = ${TARGET}-${VERSION}-amd64.aci

INIT_SCRIPT = init.sh

all: check fetch verify extract ${ACI}

check:
	wget -qO- ${CHECK_URL} \
		| grep "tag-name" \
		| cut -d \> -f2 \
		| cut -d\< -f1 \
		| head -1 \
		| grep -q ${VERSION} \
		|| ( echo "[E] A newer version is available"; exit 1)

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || \
		wget -O${BUILD_DIR}/${TARBALL} ${UPSTREAM}/${TARBALL}
	cp ${PG_SCRIPTS}/dbadmin ${BUILD_DIR}/dbadmin
	chmod 0755 ${BUILD_DIR}/dbadmin

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
