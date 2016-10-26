
BUILD_DIR = ./build

all: ${BUILD_DIR}/etcd-metrics-to-influxdb

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

${BUILD_DIR}/etcd-metrics-to-influxdb:
	go build -v -o ${BUILD_DIR}/etcd-metrics-to-influxdb \
		etcd-metrics-to-influxdb.go
	strip ${BUILD_DIR}/etcd-metrics-to-influxdb
