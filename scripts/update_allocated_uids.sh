#!/bin/sh

# Pass 1, update allocated_uids.txt
grep adduser ./src/*/Dockerfile* \
    | awk -F"-u " '{print $2}' \
    | sort | uniq | sort -n > allocated_uids.txt

# Pass 2, update ansible
cat allocated_uids.txt | while read LINE; do
    ROLE="$(echo "${LINE}" | awk '{print $2}')"
    UIDGID="$(echo "${LINE}" | awk '{print $1}')"
    ROLE_DIR="./ansible/roles/${ROLE}"
    if [[ ! -d "${ROLE_DIR}" ]]; then
        echo "[W] No ansible role defined for ${ROLE}"
        continue
    fi

    VARS_FILE="${ROLE_DIR}/vars/main.yml"
    grep -q "uidgid:" ${VARS_FILE} 2>/dev/null
    if [[ ${?} -eq 0 ]]; then
        sed -i -e "s,uidgid: .*$,uidgid: ${UIDGID},g" ${VARS_FILE}
    else
        echo "uidgid: ${UIDGID}" >> ${VARS_FILE}
    fi

done