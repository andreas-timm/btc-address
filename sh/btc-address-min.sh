#!/bin/bash
# SPDX-License-Identifier: CC-BY-4.0
# This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
# Author: Andreas Timm
# Repository: https://github.com/andreas-timm/btc-address
# Version: 0.1.1
# Commited: 2018-05-18T14:34:41+0200
# References: https://gist.github.com/colindean/5239812
# @sha256sum 0xbbeba25cd2d5ee66c0d4827f489d0f450c4b3bd6e68c4e9ec830baed9e7fbc89
# @eip191signature 0xedda3ae82dca6736e5d2965b2168bf974fa62b720ffdd412780e8a42fc3d399032b43c05a444c110d85210f238813b64eea30638c36949a3fcc2c2208882ca4e1b

function encodeBase58 {
    base58=({1..9} {A..H} {J..N} {P..Z} {a..k} {m..z})
    printf %s "$1" | sed -e's/^\(\(00\)*\).*/\1/' -e's/00/1/g' | tr -d '\n'
    bc <<<"ibase=16; n=$(tr '[:lower:]' '[:upper:]' <<< "$1"); while(n>0) { n%3A ; n/=3A }" |
    while read -r n; do printf %s "${base58[n]}"; done
}

entropy=$1

priv=$(printf %s "$entropy" | openssl dgst -sha256 | awk '{print $2}')
priv_ec=$(printf %s "302e0201010420${priv}a00706052b8104000a" | xxd -r -p | openssl ec -inform DER 2>/dev/null)

pub_ec=$(echo "$priv_ec" | openssl ec -pubout -outform PEM 2>/dev/null)
pub=$(echo "$pub_ec" | tail -n+2 | head -n2 | base64 -d | tail -c65 | xxd -p | tr -d \\n)

hash160=$(echo "$pub" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p)
hash160Prepared=00${hash160}
checksum=$(
    echo "$hash160Prepared" | xxd -r -p |
    openssl dgst -sha256 -binary |
    openssl dgst -sha256 -binary |
    xxd -p -l4
)
address=$(encodeBase58 "${hash160Prepared}${checksum}")

echo "$address $priv"
