FROM alpine:latest
MAINTAINER Lex van Roon <r3boot@r3blog.nl>

RUN apk update \
    && apk upgrade \
    && apk add db hiredis libidn libnsl libspf2 libldap pcre postgresql-libs \
    && addgroup -S -g 809 exim \
    && adduser -S -G exim -u 809 exim

COPY exim-build/exim/build-Linux-x86_64/exigrep \
    exim-build/exim/build-Linux-x86_64/exim \
    exim-build/exim/build-Linux-x86_64/exim_checkaccess \
    exim-build/exim/build-Linux-x86_64/exim_dbmbuild \
    exim-build/exim/build-Linux-x86_64/exim_dumpdb \
    exim-build/exim/build-Linux-x86_64/exim_fixdb \
    exim-build/exim/build-Linux-x86_64/exim_lock \
    exim-build/exim/build-Linux-x86_64/eximstats \
    exim-build/exim/build-Linux-x86_64/exim_tidydb \
    exim-build/exim/build-Linux-x86_64/exinext \
    exim-build/exim/build-Linux-x86_64/exipick \
    exim-build/exim/build-Linux-x86_64/exiqgrep \
    exim-build/exim/build-Linux-x86_64/exiqsumm \
    exim-build/exim/build-Linux-x86_64/exiwhat \
    /usr/sbin/

COPY files/run_exim /run_exim

ENTRYPOINT ["/run_exim"]
CMD [""]
