#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

BUNDLEJOBS=$(expr $(cat /proc/cpuinfo | grep vendor_id | wc -l) - 1)

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name metasploit
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add openssl postgresql nmap ruby gcc git make ncurses ruby-dev musl-dev zlib-dev libffi-dev sqlite-dev postgresql-dev libpcap-dev
acbuild --debug run -- gem install rake bundler io-console --no-ri --no-rdoc
acbuild --debug copy build/metasploit-framework-${VERSION} /opt/msf
acbuild --debug copy files/Gemfile.local /opt/msf/Gemfile.local
acbuild --debug run -- bundle config --global jobs ${BUNDLEJOBS}
acbuild --debug run -- bundle install --gemfile /opt/msf/Gemfile.local
acbuild --debug run -- ln -s /opt/msf/msf* /usr/bin/
acbuild --debug run -- ln -s /opt/msf/tools/*/* /usr/bin/
acbuild --debug copy files/metasploit.sql /var/lib/postgresql/metasploit.sql
acbuild --debug copy files/database.yml /opt/msf/config/database.yml
acbuild --debug run -- sh -c "mkdir -p /run/openrc && touch /run/openrc/softlevel && /etc/init.d/postgresql setup"
acbuild --debug run -- su - postgres -c "pg_ctl -D /var/lib/postgresql/9.5/data start -s -w -l /var/lib/postgresql/postmaster.log ; psql -f /var/lib/postgresql/metasploit.sql ; pg_ctl -D /var/lib/postgresql/9.5/data stop"
acbuild --debug copy files/run_msfconsole /usr/bin/run_msfconsole
acbuild --debug run -- apk del gcc ruby-dev musl-dev zlib-dev libffi-dev sqlite-dev postgresql-dev libpcap-dev
acbuild --debug run -- rm -f /var/lib/postgresql/metasploit.sql
acbuild --debug run -- rm -f /var/cache/apk/*.gz
acbuild --debug mount add config /root/.msf4
acbuild --debug mount add data /tmp/data
acbuild --debug set-exec /usr/bin/run_msfconsole
acbuild --debug write --overwrite ./build/metasploit-${VERSION}-amd64.aci
acbuild end
