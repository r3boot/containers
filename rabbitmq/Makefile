TARGET = rabbitmq
BUILD_DIR = ./build
INSTALL_DIR = ./installed
FILES = ./files
SCRIPTS = ./scripts

VERSION = 3.6.5
TARBALL = rabbitmq-server-generic-unix-${VERSION}.tar.xz
UPSTREAM = https://www.rabbitmq.com/releases/rabbitmq-server/v${VERSION}
GPG_ID = 6B73A36E6026DFCA
ACI = ${TARGET}-${VERSION}-amd64.aci

ERLANG_VERSION = 19.0
ERLANG_TARBALL = OTP-${ERLANG_VERSION}.tar.gz
ERLANG_UPSTREAM = https://github.com/erlang/otp/archive
ERLANG_SHA256 = 107b629aa7aea1bf76df0197629a50ce4fea61143ebb0e9a1b633b1fbaf9beb7

all: fetch verify extract build

fetch: fetch_erlang fetch_rabbitmq

verify: verify_erlang verify_rabbitmq

extract: extract_erlang extract_rabbitmq

build: build_erlang ${ACI}

fetch_erlang:
	[[ -d ${BUILD_DIR} ]] || mkdir -vp ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${ERLANG_TARBALL} ]] || \
		wget -O${BUILD_DIR}/${ERLANG_TARBALL} ${ERLANG_UPSTREAM}/${ERLANG_TARBALL}

fetch_rabbitmq:
	[[ -d ${BUILD_DIR} ]] || mkdir -vp ${BUILD_DIR}
	[[ -f ${BUILD_DIR}/${TARBALL} ]] || \
		wget -O${BUILD_DIR}/${TARBALL} ${UPSTREAM}/${TARBALL}
	[[ -f ${BUILD_DIR}/${TARBALL}.asc ]] || \
		wget -O${BUILD_DIR}/${TARBALL}.asc ${UPSTREAM}/${TARBALL}.asc

verify_erlang:
	sha256sum ${BUILD_DIR}/${ERLANG_TARBALL} | grep ${ERLANG_SHA256}

verify_rabbitmq:
	gpg --list-keys ${GPG_ID} || gpg --recv-keys ${GPG_ID}
	gpg --verify ${BUILD_DIR}/${TARBALL}.asc

extract_erlang:
	tar xvzf ${BUILD_DIR}/${ERLANG_TARBALL} -C ${BUILD_DIR}/

extract_rabbitmq:
	tar xvJf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}/

build_erlang:
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	mkdir -p ${INSTALL_DIR}
	install -o root -g root -m 0755 ${FILES}/build_erlang.sh \
		${BUILD_DIR}/build.sh
	sed -i -e "s,%VERSION%,${ERLANG_VERSION},g" ${BUILD_DIR}/build.sh
	rkt-builder
	cd ${INSTALL_DIR} && tar cvJf ../build/erlang-${ERLANG_VERSION}-musl-amd64.tar.xz *
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -d -o root -g root -m 0750 /var/rkt/rabbitmq
	install -o root -g root -m 0644 ${FILES}/rkt-rabbitmq.service \
		/etc/systemd/system/rkt-rabbitmq.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	[[ -d ${INSTALL_DIR} ]] && rm -rf ${INSTALL_DIR} || true
	rkt image rm ${TARGET} || true
