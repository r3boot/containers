#!/bin/sh

set -x

cd /opt/graphite/webapp/graphite \
&& python manage.py syncdb --noinput \
&& chown apache:apache /opt/graphite/storage/graphite.db \
&& rm -f /root/install_django_db.sh
