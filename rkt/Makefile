TARGET = rkt
VERSION = 1.12.0

BUILD_DIR = ./build

UPSTREAM_URL = https://github.com/coreos/rkt/releases/download/v${VERSION}/
CACHE = /archive
GPG_ID = 3F1B2C87

RKT_TARBALL = rkt-v${VERSION}.tar.gz
RKT_DIR = rkt-v${VERSION}
STAGE1_COREOS = stage1-coreos-${VERSION}-linux-amd64.aci
STAGE1_FLY = stage1-fly-${VERSION}-linux-amd64.aci
STAGE1_KVM = stage1-kvm-${VERSION}-linux-amd64.aci

all: ${TARGET}

update: clean install

${TARGET}: fetch verify extract

fetch:
	[ -d ${BUILD_DIR} ] || mkdir -p ${BUILD_DIR}
	[ -f ${CACHE}/${RKT_TARBALL} ] && ( \
		cp -v ${CACHE}/${RKT_TARBALL} ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${RKT_TARBALL} ] || \
			curl \
				-L ${UPSTREAM_URL}/${RKT_TARBALL} \
				-o ${BUILD_DIR}/${RKT_TARBALL} \
	)
	[ -f ${CACHE}/${RKT_TARBALL}.asc ] && ( \
		cp -v ${CACHE}/${RKT_TARBALL}.asc ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${RKT_TARBALL}.asc ] || \
			curl \
				-L ${UPSTREAM_URL}/${RKT_TARBALL}.asc \
				-o ${BUILD_DIR}/${RKT_TARBALL}.asc \
	)
	[ -f ${CACHE}/${STAGE1_COREOS} ] && ( \
		cp -v ${CACHE}/${STAGE1_COREOS} ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${STAGE1_COREOS} ] || \
			curl \
				-L ${UPSTREAM_URL}/${STAGE1_COREOS} \
				-o ${BUILD_DIR}/${STAGE1_COREOS} \
	)
	[ -f ${CACHE}/${STAGE1_COREOS}.asc ] && ( \
		cp -v ${CACHE}/${STAGE1_COREOS}.asc ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${STAGE1_COREOS}.asc ] || \
			curl \
				-L ${UPSTREAM_URL}/${STAGE1_COREOS}.asc \
				-o ${BUILD_DIR}/${STAGE1_COREOS}.asc \
	)
	[ -f ${CACHE}/${STAGE1_FLY} ] && ( \
		cp -v ${CACHE}/${STAGE1_FLY} ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${STAGE1_FLY} ] || \
			curl \
				-L ${UPSTREAM_URL}/${STAGE1_FLY} \
				-o ${BUILD_DIR}/${STAGE1_FLY} \
	)
	[ -f ${CACHE}/${STAGE1_FLY}.asc ] && ( \
		cp -v ${CACHE}/${STAGE1_FLY}.asc ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${STAGE1_FLY}.asc ] || \
			curl \
				-L ${UPSTREAM_URL}/${STAGE1_FLY}.asc \
				-o ${BUILD_DIR}/${STAGE1_FLY}.asc \
	)
	[ -f ${CACHE}/${STAGE1_KVM} ] && ( \
		cp -v ${CACHE}/${STAGE1_KVM} ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${STAGE1_KVM} ] || \
			curl \
				-L ${UPSTREAM_URL}/${STAGE1_KVM} \
				-o ${BUILD_DIR}/${STAGE1_KVM} \
	)
	[ -f ${CACHE}/${STAGE1_KVM}.asc ] && ( \
		cp -v ${CACHE}/${STAGE1_KVM}.asc ${BUILD_DIR}/ \
	) || ( \
		[ -f ${BUILD_DIR}/${STAGE1_KVM}.asc ] || \
			curl \
				-L ${UPSTREAM_URL}/${STAGE1_KVM}.asc \
				-o ${BUILD_DIR}/${STAGE1_KVM}.asc \
	)

verify:
	gpg --list-keys | grep -q ${GPG_ID} || \
		gpg --recv-keys 3F1B2C87
	gpg --verify ${BUILD_DIR}/${RKT_TARBALL}.asc
	gpg --verify ${BUILD_DIR}/${STAGE1_COREOS}.asc
	gpg --verify ${BUILD_DIR}/${STAGE1_FLY}.asc
	gpg --verify ${BUILD_DIR}/${STAGE1_KVM}.asc

extract:
	tar xvzf ${BUILD_DIR}/${RKT_TARBALL} -C ${BUILD_DIR}/

install:
	install -o root -g root -m 0755 ${BUILD_DIR}/${RKT_DIR}/rkt \
		/usr/bin/rkt
	install -o root -g root -m 0755 \
		${BUILD_DIR}/${RKT_DIR}/scripts/setup-data-dir.sh\
		/usr/bin/setup-rkt-data-dir.sh
	install -d -o root -g root -m 0755 /usr/lib/rkt
	install -d -o root -g root -m 0755 /usr/lib/rkt/stage1-images
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${STAGE1_COREOS} \
		/usr/lib/rkt/stage1-images/stage1-coreos.aci
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${STAGE1_FLY} \
		/usr/lib/rkt/stage1-images/stage1-fly.aci
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${STAGE1_KVM} \
		/usr/lib/rkt/stage1-images/stage1-kvm.aci
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${RKT_DIR}/init/systemd/rkt-metadata.socket \
		/etc/systemd/system/rkt-metadata.socket
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${RKT_DIR}/init/systemd/rkt-metadata.service \
		/etc/systemd/system/rkt-metadata.service
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${RKT_DIR}/init/systemd/rkt-gc.timer \
		/etc/systemd/system/rkt-gc.timer
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${RKT_DIR}/init/systemd/rkt-gc.service \
		/etc/systemd/system/rkt-gc.service
	install -o root -g root -m 0644 \
		${BUILD_DIR}/${RKT_DIR}/init/systemd/tmpfiles.d/rkt.conf \
		/etc/tmpfiles.d/rkt.conf
	install -o root -g root -m 0644 files/rkt.sh /etc/profile.d/rkt.sh
	install -d -o root -g root -m 0755 /etc/rkt
	install -d -o root -g root -m 0755 /etc/rkt/net.d
	install -o root -g root -m 0644 files/default.conf /etc/rkt/net.d/default.conf

clean:
	[ -d ${BUILD_DIR} ] && rm -rf ${BUILD_DIR} || true
