TARGET = $(shell basename ${PWD})
VERSION = $(shell cat version.txt)
TMPFILE = $(shell mktemp)
NAMESPACE = as65342

VERSION_TAG = ${NAMESPACE}/${TARGET}:${VERSION}
LATEST_TAG = ${NAMESPACE}/${TARGET}:latest

all: build push

build:
	docker build --no-cache --rm -t ${VERSION_TAG} -f Dockerfile .
	docker tag ${VERSION_TAG} ${LATEST_TAG}

push:
	docker push ${VERSION_TAG}
	docker push ${LATEST_TAG}

clean:
	docker image rm ${VERSION_TAG} ${LATEST_TAG} || true
