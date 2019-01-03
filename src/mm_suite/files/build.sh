#!/bin/sh

BUILD_DIR='/build'
TMP_DIR='/tmp'

find /usr | sort > ${TMP_DIR}/pre-install.txt
pip3 install postorius
pip3 install hyperkitty
pip3 install whoosh
find /usr | sort > ${TMP_DIR}/post-install.txt

diff -u ${TMP_DIR}/pre-install.txt ${TMP_DIR}/post-install.txt  \
    | grep ^+/ | sed -e 's,^+,,g' > ${TMP_DIR}/filelist.txt
pip3 show postorius | awk /^Version/'{print $2}' > ${BUILD_DIR}/version.txt
tar cvJ -T ${TMP_DIR}/filelist.txt \
    -f ${BUILD_DIR}/mm_suite-$(cat ${BUILD_DIR}/version.txt)-$(uname -m).tar.xz