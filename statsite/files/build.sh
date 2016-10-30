#!/bin/sh

apk add libtool python \
&& cd /workspace \
&& git clone https://github.com/statsite/statsite.git \
&& cd statsite \
&& git checkout --detach v0.8.0 \
&& ./bootstrap.sh \
&& ./configure --prefix=/opt/statsite-0.8.0 --sysconfdir=/etc/statsite \
&& make \
&& make install \
&& ln -s /opt/statsite-0.8.0 /opt/statsite
