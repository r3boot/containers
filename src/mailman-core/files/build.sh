#!/bin/sh

BUILDDIR='/build'
TMPDIR='/tmp'

cd ${TMPDIR}
git clone https://gitlab.com/mailman/mailman.git
cd ${TMPDIR}/mailman
find /usr | sort > ${TMPDIR}/pre-install.txt
python3 setup.py install
easy_install-3.6 psycopg2-binary
find /usr | sort > ${TMPDIR}/post-install.txt
diff -u ${TMPDIR}/pre-install.txt ${TMPDIR}/post-install.txt  \
    | grep ^+/ | sed -e 's,^+,,g' > ${TMPDIR}/filelist.txt
grep ^VERSION src/mailman/version.py \
    | cut -d"'" -f2 | sed -e 's,+$,,g' > ${BUILDDIR}/version.txt
tar cvJf ${BUILDDIR}/mailman-$(cat ${BUILDDIR}/version.txt)-$(uname -m).tar.xz \
    $(cat ${TMPDIR}/filelist.txt)
