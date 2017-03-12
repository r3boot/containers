#!/bin/sh

CFSSL_DIR='/var/rkt/cfssl'
cd ${CFSSL_DIR}

if [[ ! -f "${CFSSL_DIR}/ca.pem" ]]; then
  cfssl gencert -initca ca-csr.json | cfssljson -bare ca
fi

if [[ ! -f "${CFSSL_DIR}/intermediary-ca.pem" ]]; then
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config=cfssl-config.json \
    -profile=intermediate intermediary-csr.json \
    | cfssljson -bare intermediary-ca
fi

if [[ ! -f "${CFSSL_DIR}/ca-bundle.pem" ]]; then
  cfssl bundle -cert intermediary-ca.pem -ca-bundle=ca.pem | cfssljson -bare ca
fi
