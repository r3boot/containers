TARGET = graphite
BUILD_DIR = ./build
SCRIPTS = ./scripts

VERSION = 0.9.15
TIMEZONE = 'Europe/Amsterdam'
MEMCACHED = memcached.service.local:11211
KEY = $(shell openssl rand -hex 96)

ACI = ${TARGET}-${VERSION}-amd64.aci

all: ${ACI}

${ACI}:
	[[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR}
	install -o root -g root -m 0644 files/local_settings.py \
		build/local_settings.py
	sed -i \
		-e "s,UNSAFE_DEFAULT,${KEY},g" \
		-e "s,^#TIME_ZONE.*,TIME_ZONE=${TIMEZONE},g" \
		-e "s,127.0.0.1:11211,${MEMCACHED},g" \
		build/local_settings.py
	${SCRIPTS}/build_aci.sh ${VERSION}

install:
	rkt fetch --insecure-options=image ${BUILD_DIR}/${ACI}
	install -d -o 100 -m 0750 /var/rkt/graphite-carbon
	install -o root -g root -m 0644 files/rkt-${TARGET}.service \
		/etc/systemd/system/rkt-${TARGET}.service

clean:
	[[ -d ${BUILD_DIR} ]] && rm -rf ${BUILD_DIR} || true
	rkt image rm ${TARGET} || true
