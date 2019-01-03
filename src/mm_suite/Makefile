TARGET = mm_suite
NAMESPACE = as65342

BUILD_DIR = "${TARGET}-build"

VERSION = $(shell cat version.txt)

VERSION_TAG = ${NAMESPACE}/${TARGET}:${VERSION}
LATEST_TAG = ${NAMESPACE}/${TARGET}:latest
BUILD_TAG = ${NAMESPACE}/${TARGET}-build:latest

all: compile build

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

compile: ${BUILD_DIR}
	docker build --no-cache --rm -t $(BUILD_TAG) -f Dockerfile.build .
	docker run -it --rm \
		-v $(shell pwd)/$(shell basename ${BUILD_DIR}):/build \
		${BUILD_TAG}
	docker image rm ${BUILD_TAG}
	install ${BUILD_DIR}/version.txt version.txt

build:
	docker build --no-cache --rm \
		-t ${NAMESPACE}/${TARGET}:$(shell cat version.txt) \
		-f Dockerfile .
	docker tag ${NAMESPACE}/${TARGET}:$(shell cat version.txt) \
		${LATEST_TAG}
	docker push ${NAMESPACE}/${TARGET}:$(shell cat version.txt)
	docker push ${LATEST_TAG}

clean:
	[[ -d "${BUILD_DIR}" ]] && sudo rm -rf "${BUILD_DIR}" || true
	docker image rm ${NAMESPACE}/${TARGET}:$(shell cat version.txt) || true
	docker image rm ${LATEST_TAG} || true
