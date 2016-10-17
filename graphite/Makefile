TARGET = graphite
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 0.9.15

CARBON_ACI = ${TARGET}-carbon-${VERSION}-amd64.aci

all: ${CARBON_ACI}

${CARBON_ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_carbon_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${CARBON_ACI}
	install -d -o 100 -m 0750 /var/rkt/graphite-carbon
	install -o root -g root -m 0644 files/rkt-${TARGET}-carbon.service \
		/etc/systemd/system/rkt-${TARGET}-carbon.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET}-carbon || true
