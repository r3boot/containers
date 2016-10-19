#!/bin/sh

set -x

GITHUB='https://github.com/graphite-project'
VERSION='0.9.15'

apk add uwsgi uwsgi-python libffi cairo openldap \
&& apk add git python python-dev py-pip gcc musl-dev libffi-dev cairo-dev openldap-dev \
&& pip install python-ldap \
&& git clone ${GITHUB}/graphite-web.git /tmp/graphite-web \
&& cd /tmp/graphite-web \
&& git checkout ${VERSION} \
&& pip install -r requirements.txt \
&& python check-dependencies.py \
&& python setup.py install \
&& mv /opt/graphite/conf/dashboard.conf.example /opt/graphite/conf/dashboard.conf \
&& mv /opt/graphite/conf/graphTemplates.conf.example /opt/graphite/conf/graphTemplates.conf \
&& apk del git gcc binutils-libs binutils gmp isl libgomp libgcc pkgconf pkgconfig mpfr3 mpc1 python-dev musl-dev libffi-dev cairo-dev expat-dev zlib-dev libpng-dev freetype-dev fontconfig-dev libxau-dev libxdmcp-dev libxcb-dev xf86bigfontproto-dev libx11-dev libxrender-dev pixman-dev xcb-util-dev gettext-dev bzip2-dev glib-dev openssl-dev cyrus-sasl-dev util-linux-dev openldap-dev apr-util-dev db-dev postgresql-dev sqlite-dev openldap-dev cyrus-sasl-dev openssl-dev zlib-dev util-linux-dev expat-dev \
&& rm -rf /root/.cache /tmp/graphite-web
