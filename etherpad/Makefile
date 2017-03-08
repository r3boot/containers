TARGET = etherpad
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 1.6.1
TARBALL = ${VERSION}.tar.gz
UPSTREAM = https://github.com/ether/etherpad-lite/archive/${TARBALL}
ACI = ${TARGET}-${VERSION}-amd64.aci
SHA256SUM = 78593ce0f0a7fa43611d38b7bda62c9ecc062061e61e34e14e3bf2a3c110a645

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt
	install -d -o root -g root -m 0750 /var/rkt/etherpad
	install -o root -g root -m 0755 ${BUILD_DIR}/etherpad-v${VERSION}-linux-amd64/etcdctl \
		../scripts/etherpadctl

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${ACI_NAME} || true
