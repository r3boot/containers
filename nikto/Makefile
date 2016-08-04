TARGET = nikto
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 2.1.5
ACI_NAME = nikto
ACI = ${TARGET}-${VERSION}-amd64.aci

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${ACI_NAME} || true
