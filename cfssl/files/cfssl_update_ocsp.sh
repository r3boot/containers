#!/bin/sh

CFSSL_DIR='/var/rkt/cfssl'
cd ${CFSSL_DIR}

if [[ ! -f "${CFSSL_DIR}/ocsp-ca.pem" ]]; then
  cfssl gencert -ca intermediary-ca.pem -ca-key intermediary-ca-key.pem \
    -config cfssl-config.json -profile="ocsp" ocsp-csr.json \
    | cfssljson -bare ocsp-ca
fi
