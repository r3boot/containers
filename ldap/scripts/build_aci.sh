#!/bin/sh

# Set version
VERSION="latest"
if [ ${#} -eq 1 ]; then
    VERSION="${1}"
fi

# Generate machine id for this container
openssl rand -hex 16 > build/machine-id

acbuild begin
acbuild --debug dependency add quay.io/coreos/alpine-sh
acbuild --debug set-name ldap
acbuild --debug annotation add version "${VERSION}"
acbuild --debug annotation add author "Lex van Roon <r3boot@r3blog.nl>"
acbuild --debug copy build/machine-id /etc/machine-id
acbuild --debug copy files/resolv.conf /etc/resolv.conf
acbuild --debug copy files/repositories /etc/apk/repositories
acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add openssl ca-certificates
acbuild --debug run -- apk add openldap openldap-back-hdb openldap-back-monitor openldap-clients
acbuild --debug copy files/ldapns.schema /etc/openldap/schema/ldapns.schema
acbuild --debug copy files/mail.schema /etc/openldap/schema/mail.schema
acbuild --debug copy files/samba.schema /etc/openldap/schema/samba.schema
acbuild --debug copy files/directory.ldif /root/directory.ldif
acbuild --debug run -- chown root:root /root/directory.ldif
acbuild --debug run -- rm -f /etc/openldap/*.default /etc/openldap/*.ldif /etc/openldap/*.example /etc/openldap/schema/*.ldif
acbuild --debug run -- install -d -o root -g ldap -m 0750 /var/lib/openldap
acbuild --debug run -- install -d -o ldap -g ldap -m 0770 /var/run/slapd
acbuild --debug copy build/cfssl /usr/sbin/cfssl
acbuild --debug copy build/cfssljson /usr/sbin/cfssljson
acbuild --debug copy build/update_certs /usr/sbin/update_certs
acbuild --debug run -- install -d -o root -g ldap -m 0750 /etc/cfssl
acbuild --debug run -- install -d -o root -g ldap -m 0750 /etc/cfssl/ldap
acbuild --debug copy build/ca-bundle.pem /etc/ssl/certs/ca-bundle.pem
acbuild --debug run -- chown root:ldap /etc/ssl/certs/ca-bundle.pem
acbuild --debug run -- chmod 0644 /etc/cfssl/ca-bundle.pem
acbuild --debug run -- c_rehash /etc/ssl/certs
acbuild --debug copy build/confd /usr/sbin/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/conf.d
acbuild --debug run -- install -d -o root -g root -m 0750 /etc/confd/templates
acbuild --debug copy files/confd.toml /etc/confd/confd.toml
acbuild --debug copy files/config_json.toml /etc/confd/conf.d/config_json.toml
acbuild --debug copy files/config.json.tmpl /etc/confd/templates/config.json.tmpl
acbuild --debug copy files/ldap_conf.toml /etc/confd/conf.d/ldap_conf.toml
acbuild --debug copy files/ldap.conf.tmpl /etc/confd/templates/ldap.conf.tmpl
acbuild --debug copy files/slapd_conf.toml /etc/confd/conf.d/slapd_conf.toml
acbuild --debug copy files/slapd.conf.tmpl /etc/confd/templates/slapd.conf.tmpl
acbuild --debug copy files/DB_CONFIG.toml /etc/confd/conf.d/DB_CONFIG.toml
acbuild --debug copy files/DB_CONFIG.tmpl /etc/confd/templates/DB_CONFIG.tmpl
acbuild --debug copy files/run_slapd /usr/sbin/run_slapd
acbuild --debug mount add data /var/lib/openldap/openldap-data/
acbuild --debug set-exec /usr/sbin/run_slapd
acbuild --debug write ./build/ldap-${VERSION}-amd64.aci
acbuild end
