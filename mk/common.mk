TARGET = $(shell basename ${PWD})
TMPFILE = $(shell mktemp)
NAMESPACE = as65342

ifndef VERSION
$(error VERSION is not set)
endif

VERSION_TAG = ${NAMESPACE}/${TARGET}:${VERSION}
LATEST_TAG = ${NAMESPACE}/${TARGET}:latest

all: build

build:
	docker build --no-cache --rm -t ${VERSION_TAG} -f Dockerfile .
	docker tag ${VERSION_TAG} ${LATEST_TAG}
	docker push ${VERSION_TAG}
	docker push ${LATEST_TAG}

clean:
	docker image rm ${VERSION_TAG} ${LATEST_TAG} || true
