TARGET = rkt-registrator
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = latest
UPSTREAM = https://github.com/r3boot/${TARGET}
ACI = ${TARGET}-${VERSION}-amd64.aci

all: fetch compile ${ACI}

fetch:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	[[ -d ${BUILD_DIR}/${TARGET} ]] && \
		(cd ${BUILD_DIR}/${TARGET} ; git pull) || \
		git clone ${UPSTREAM} ${BUILD_DIR}/${TARGET} 

compile:
	mkdir -p ${BUILD_DIR}/src/github.com/r3boot
	cd ${BUILD_DIR}/src/github.com/r3boot ; ln -s ../../../rkt-registrator
	cd ${BUILD_DIR} ; export GOPATH=`pwd` ; cd rkt-registrator ; go build -v


${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -o root -g root -m 0644 files/${TARGET}.service \
		/etc/systemd/system/${TARGET}.service
	install -d -o root -g root -m 0755 /var/rkt
	install -d -o root -g root -m 0750 /var/rkt/etcd

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${ACI_NAME} || true
