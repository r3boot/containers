#!/bin/sh

set -x

GITHUB='https://github.com/graphite-project'
VERSION='0.9.15'

apk add python py-pip git gcc python-dev musl-dev \
&& git clone ${GITHUB}/whisper.git /tmp/whisper \
&& cd /tmp/whisper \
&& git checkout ${VERSION} \
&& python setup.py install \
&& git clone ${GITHUB}/carbon.git /tmp/carbon \
&& cd /tmp/carbon \
&& git checkout ${VERSION} \
&& pip install -r requirements.txt \
&& python setup.py install \
&& apk del git gcc binutils-libs binutils gmp isl libgomp libgcc pkgconf pkgconfig mpfr3 mpc1 python-dev musl-dev \
&& rm -rf /root/.cache /tmp/whisper /tmp/carbon /root/install_graphite_carbon.sh
