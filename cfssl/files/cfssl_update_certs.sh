#!/bin/sh

CFSSL_DIR='/etc/cfssl'
cd ${CFSSL_DIR}

ls ${CFSSL_DIR} | while read SERVICE; do
  echo "[+] Generating key for ${SERVICE}"
  cd ${CFSSL_DIR}/${SERVICE}
  cfssl genkey config.json | cfssljson -bare ${SERVICE}
  cfssl sign -remote pki.as65342.net:8888 -profile "server" \
    ${SERVICE}.csr | cfssljson -bare ${SERVICE}
  cat ${SERVICE}.pem ${SERVICE}-key.pem > ${SERVICE}-haproxy.pem
  chown root:haproxy ${SERVICE}-haproxy.pem
  chmod 0640 ${SERVICE}-haproxy.pem
done
