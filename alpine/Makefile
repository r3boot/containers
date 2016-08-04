TARGETS = alpine
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 3.4
UPSTREAM = quay.io/coreos/alpine-sh:latest
ACI_NAME = alpine
ACI = alpine-${VERSION}-amd64.aci

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${ACI_NAME} || true
