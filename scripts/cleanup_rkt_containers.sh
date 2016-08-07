#!/bin/sh

if [ ${#} -ne 1 ]; then
    echo "Usage: $(basename ${0}) <container>"
    exit 1
fi

IDS="$(rkt list | grep ${1} | awk '{print $1}')"
if [ ! -z "${IDS}" ]; then
    rkt rm ${IDS}
fi
