TARGET = acbuild

BUILD_DIR = ./build

VERSION = 0.4.0
TARBALL = acbuild-v${VERSION}.tar.gz
UPSTREAM_URL = https://github.com/appc/acbuild/releases/download/v${VERSION}
GPG_ID = 84580913

all: ${TARGET}

update: clean install

${TARGET}: fetch verify extract

fetch:
	[ -d ${BUILD_DIR} ] || mkdir -p ${BUILD_DIR}
	[ -f ${BUILD_DIR}/${TARBALL} ] || \
		curl \
			-L ${UPSTREAM_URL}/${TARBALL} \
			-o ${BUILD_DIR}/${TARBALL} \
	[ -f ${BUILD_DIR}/${TARBALL}.asc ] || \
		curl \
			-L ${UPSTREAM_URL}/${TARBALL}.asc \
			-o ${BUILD_DIR}/${TARBALL}.asc \

verify:
	gpg --list-keys ${GPG_ID} || gpg --recv-keys ${GPG_ID}
	gpg --verify ${BUILD_DIR}/${TARBALL}.asc

extract:
	tar xvzf ${BUILD_DIR}/${TARBALL} -C ${BUILD_DIR}/

install:
	install -d -o root -g root -m 0755 /opt/acbuild
	install -o root -g root -m 0755 ${BUILD_DIR}/acbuild-v${VERSION}/acbuild \
		/opt/acbuild/acbuild
	install -o root -g root -m 0755 ${BUILD_DIR}/acbuild-v${VERSION}/acbuild-chroot \
		/opt/acbuild/acbuild-chroot
	install -o root -g root -m 0755 ${BUILD_DIR}/acbuild-v${VERSION}/acbuild-script \
		/opt/acbuild/acbuild-script
	install -o root -g root -m 0644 files/acbuild.sh /etc/profile.d/acbuild.sh

clean:
	[ -d ${BUILD_DIR} ] && rm -rf ${BUILD_DIR} || true
