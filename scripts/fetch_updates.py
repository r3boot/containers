#!/usr/bin/env python

import os
import re
import requests
import sys

BASE_URL = 'http://dl-cdn.alpinelinux.org/alpine'
STABLE_MAIN = '{0}/latest-stable/main/x86_64'.format(BASE_URL)
EDGE_MAIN = '{0}/edge/main/x86_64'.format(BASE_URL)
EDGE_TESTING = '{0}/edge/testing/x86_64'.format(BASE_URL)

TOP_DIR = '/'.join(os.path.abspath(sys.argv[0]).split('/')[:-2])

IGNORED_DIRS = ['.idea', 'scripts']

RE_PACKAGE_VERSION = re.compile('(.*)-([0-9.]+.*-r[0-9]+).apk')


def info(msg):
    print('[+] {0}'.format(msg))


def warning(msg):
    print('[+] {0}'.format(msg))


def error(msg):
    print("[E] {0}".format(msg))
    sys.exit(1)


def find_matching_updates(url, containers):
    updates = {}
    info("Fetching {0}".format(url))
    resp = requests.get(url)
    if resp.status_code != 200:
        error("GET of {0} returned {1}".format(url, resp.status_code))

    for rawline in resp.text.split():
        if 'apk' not in rawline:
            continue
        package_fullname = rawline.split('"')[1]
        match = RE_PACKAGE_VERSION.search(package_fullname)
        if not match:
            continue
        name = match.group(1)
        version = match.group(2)

        for container in containers:
            if container.startswith(name):
                updates[container] = version
    return updates


def update_version(container, version):
    info('Updating {0} to {1}'.format(container, version))
    with open('{0}/src/{1}/version.txt'.format(TOP_DIR, container), 'w') as fd:
        fd.write(version)

    ansible_dir = '{0}/ansible/roles/{1}/vars'.format(TOP_DIR, container)
    if not os.path.exists(ansible_dir):
        warning("No ansible role defined for {0}".format(container))
        return

    vars_file = '{0}/main.yml'.format(ansible_dir)
    if not os.path.exists(vars_file):
        with open(vars_file, 'w') as fd:
            fd.write('version: {0}\n'.format(version))
    else:
        new_vars_file = '{0}.new'.format(vars_file)
        with open(vars_file, 'r') as src_fd:
            with open(new_vars_file, 'w+') as dst_fd:
                dst_fd.write('version: {0}\n'.format(version))
                for line in src_fd.readlines():
                    if line.startswith('version:'):
                        continue
                    dst_fd.write('{0}\n'.format(line))
        os.rename(new_vars_file, vars_file)


if __name__ == '__main__':
    local_containers = []
    for dirname in (os.listdir("{0}/src/".format(TOP_DIR))):
        if not os.path.isdir("src/{0}".format(dirname)):
            continue
        if dirname in IGNORED_DIRS:
            continue
        local_containers.append(dirname)

    stable_main = find_matching_updates(STABLE_MAIN, local_containers)
    edge_main = find_matching_updates(EDGE_MAIN, local_containers)
    edge_testing = find_matching_updates(EDGE_TESTING, local_containers)

    for pkg in stable_main:
        if pkg in edge_main:
            continue
        if pkg in edge_testing:
            continue
        update_version(pkg, stable_main[pkg])

    for pkg in edge_main:
        update_version(pkg, edge_main[pkg])

    for pkg in edge_testing:
        update_version(pkg, edge_testing[pkg])
