#! /bin/bash
# Copyright (c) SanCloud Ltd 2021
# SPDX-License-Identifier: MIT

set -euo pipefail

VERSION="v0.1.1"
DESTDIR="/lib/firmware"
INSTALLOPTS=""

usage() {
    cat << EOF
SanCloud firmware ${VERSION} install script.
Usage: $0 [-d DESTDIR] [-v] [-V] [-h]

Options:
  -d DESTDIR:   Destination directory for firmware files, defaults to
                '/lib/firmware'.
  -v:           Print verbose output during installation.
  -V:           Print firmware version and exit.
  -h:           Print help and exit.
EOF
}

while getopts "d:vVh" opt; do
    case $opt in
        d)
            DESTDIR="$OPTARG"
            ;;
        v)
            INSTALLOPTS="-v"
            ;;
        V)
            echo "${VERSION}"
            exit 0
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage > /dev/stderr
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))
if [ $# -gt 0 ]; then
    usage > /dev/stderr
    exit 1
fi

install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}"
install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}/qcacld2"
install ${INSTALLOPTS} -m 0644 \
        qca6174a/bdwlan30.bin \
        qca6174a/otp30.bin \
        qca6174a/qwlan30.bin \
        qca6174a/utf30.bin \
        "${DESTDIR}/qcacld2/"

install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}/wlan"
install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}/wlan/qcacld2"
install ${INSTALLOPTS} -m 0644 \
        qca6174a/wlan/qcom_cfg.ini \
        "${DESTDIR}/wlan/qcacld2/"

install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}"
install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}/qca9377"
install ${INSTALLOPTS} -m 0644 \
        qca9377/bdwlan30.bin \
        qca9377/otp30.bin \
        qca9377/qwlan30.bin \
        qca9377/utf30.bin \
        "${DESTDIR}/qca9377/"

install ${INSTALLOPTS} -m 0755 -d "${DESTDIR}/wlan"
install ${INSTALLOPTS} -m 0644 \
        qca9377/wlan/qcom_cfg.ini \
        "${DESTDIR}/wlan/"

echo "Installed firmware to '${DESTDIR}'."
