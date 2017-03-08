BUILD_DIR = ./build
INSTALLED_DIR = ./installed
SCRIPTS_DIR = ../scripts

all: build

build:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p ${BUILD_DIR}
	[[ -d "${INSTALLED_DIR}" ]] || mkdir -p ${INSTALLED_DIR}
	install -o root -g root -m 0755 ./files/build.sh ${BUILD_DIR}/build.sh
	rkt-builder

install:
	install -o root -g root -m 0755 \
		${BUILD_DIR}/bin/confd \
		${SCRIPTS_DIR}/confd

clean:
	[[ -d "${BUILD_DIR}" ]] && rm -rf ${BUILD_DIR} || true
	[[ -d "${INSTALLED_DIR}" ]] && rm -rf ${INSTALLED_DIR} || true
	[[ -d "./src/build" ]] && rm -rf ./src/build || true
