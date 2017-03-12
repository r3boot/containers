#!/bin/sh

TMPDIR="$(mktemp -d)"
trap "rm -rf ${TMPDIR}" SIGINT SIGTERM EXIT

GOPATH="${TMPDIR}"
DB_DIR="$GOPATH/src/github.com/cloudflare/cfssl/certdb/pg"
export GOPATH

echo '[+] go get github.com/cloudflare/cfssl'
go get github.com/cloudflare/cfssl 2>/dev/null
cat > ${DB_DIR}/dbconf.yml <<EOF
production:
    driver: postgres
    open: user=cfssl host=postgresql.service.as65342 dbname=cfssl password=r8cPwON24LEWM sslmode=disable
EOF

echo '[+] goose -env production -path ${DB_DIR} up'
goose -env production -path ${DB_DIR} up
