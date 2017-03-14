#!/bin/sh

CFSSL_DIR='/var/rkt/cfssl'
cd ${CFSSL_DIR}

cfssl bundle -cert intermediary-ca.pem -ca-bundle ca.pem | cfssljson -bare ca
install -o root -g root -m 0644 ca-bundle.pem /etc/ssl/certs/ca-bundle.pem
