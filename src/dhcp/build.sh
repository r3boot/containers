#!/usr/bin/env bash

VERSION='4.3.5'

TMPFILE="$(mktemp)"
trap "rm -f ${TMPFILE}" EXIT INT TERM

docker build . | tee ${TMPFILE}
ID="$(tail -1 ${TMPFILE} | awk '{print $3}')"
DEST="as65342/k8s-dhcpd:${VERSION}"
echo "[+] Setting tag to ${DEST}"
docker tag ${ID} ${DEST}
echo '[+] pushing to docker hub'
docker push ${DEST}
