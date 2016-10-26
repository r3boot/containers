BUILD_DIR = ./build
INSTALLED_DIR = ./installed

all: build_agents

build_agents:
	[[ -d "${BUILD_DIR}" ]] || mkdir -p ${BUILD_DIR}
	[[ -d "${INSTALLED_DIR}" ]] || mkdir -p ${INSTALLED_DIR}
	install -o root -g root -m 0755 ./files/build.sh ${BUILD_DIR}/build.sh
	cp -Rp src ${BUILD_DIR}/src
	rkt-builder

clean:
	[[ -d "${BUILD_DIR}" ]] && rm -rf ${BUILD_DIR}
	[[ -d "${INSTALLED_DIR}" ]] && rm -rf ${INSTALLED_DIR}
