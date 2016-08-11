#!/bin/sh

PREFIX_BASE='/opt'
WORKSPACE='/workspace'
BUILD_SCRIPT="${WORKSPACE}/build.sh"

if [[ ! -d "${WORKSPACE}" ]]; then
  echo "[E] ${WORKSPACE} does not exist, dropping you into a shell"
  exec /bin/sh
fi

if [[ ! -f "${BUILD_SCRIPT}" ]]; then
  echo "[E] ${BUILD_SCRIPT} does not exist, dropping you into a shell"
  exec /bin/sh
fi

if [[ ! -d "${PREFIX_BASE}" ]]; then
  echo "[W] ${PREFIX_BASE} not found, abort build? [Y/n]"
  read ANSWER
  if [[ "$(echo ${ANSWER} | tr a-z A-Z)" == "Y" ]]; then
    echo "[*] Dropping you into a shell"
    exec /bin/sh
  fi
fi

echo "[*] Starting build on $(date)"
/bin/sh ${BUILD_SCRIPT}
echo "[*] Build ended on $(date)"
