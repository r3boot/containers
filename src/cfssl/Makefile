TARGET = cfssl
VERSION = latest
NAMESPACE = as65342

LATEST_TAG = $(NAMESPACE)/$(TARGET):latest
OCSP_LATEST_TAG = $(NAMESPACE)/ocsp:latest
BUILD_TAG = $(NAMESPACE)/$(TARGET)-build:latest

BUILD_DIR = ./go/x86_64/musl
BUILD_NATIVE_DIR = ./go/x86_64/glibc

CFSSL_TARBALL = cfssl-latest.tar.xz

GOPATH = $(shell readlink -f $(BUILD_NATIVE_DIR))

all: clean $(BUILD_DIR)/bin/cfssl build tarball

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_NATIVE_DIR):
	mkdir -p $(BUILD_NATIVE_DIR)

$(BUILD_DIR)/bin/cfssl: $(BUILD_DIR)
	docker build --no-cache --rm -t $(BUILD_TAG) -f Dockerfile.build .
	docker run -it --rm -v $(shell pwd)/$(BUILD_DIR):/build $(BUILD_TAG)
	docker image rm $(BUILD_TAG)

build:
	docker build --no-cache --rm -t $(LATEST_TAG) -f Dockerfile .
	docker push $(LATEST_TAG)
	docker build --no-cache --rm -t $(OCSP_LATEST_TAG) -f Dockerfile.ocsp .
	docker push $(OCSP_LATEST_TAG)

build_native: $(BUILD_NATIVE_DIR)
	CGO_ENABLED=0 GOOS=linux go get -v github.com/cloudflare/cfssl/cmd/...

tarball: build_native
	tar cvJf $(CFSSL_TARBALL) $(BUILD_NATIVE_DIR)/bin

clean:
	[[ -d "$(BUILD_DIR)" ]] && sudo rm -rf "$(BUILD_DIR)" || true
	[[ -d "$(BUILD_DIR)" ]] && rm -rf "$(BUILD_NATIVE_DIR)" || true
	[[ -f "$(CFSSL_TARBALL)" ]] && rm -f "$(CFSSL_TARBALL)" || true
	docker image rm $(LATEST_TAG) || true
	docker image rm $(BUILD_TAG) || true
