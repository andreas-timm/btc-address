#!/bin/bash
# SPDX-License-Identifier: CC-BY-4.0
# This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
# Author: Andreas Timm
# Repository: https://github.com/andreas-timm/btc-address
# Version: 0.1.1
# Commited: 2018-05-18T14:34:41+0200
# References: https://gist.github.com/colindean/5239812
# @eip191signature 0xbca5ef6c9951fbb7a11dea2dd584de0c0cc7dc0cb572ed99dcec7e21a96ec975247f701591e1ddf6e1a2b78daa852fc77824b7f48e0bb08b9cd812f501e6d8da1c
# @sha256sum 0x0b55829ac687100ba63d317bee4f1229a9cdf1329a5a68ff27dd44572006df66

function encodeBase58 {
    base58=({1..9} {A..H} {J..N} {P..Z} {a..k} {m..z})
    printf %s "$1" | sed -e's/^\(\(00\)*\).*/\1/' -e's/00/1/g' | tr -d '\n'
    bc <<<"ibase=16; n=$(tr '[:lower:]' '[:upper:]' <<< "$1"); while(n>0) { n%3A ; n/=3A }" |
    while read -r n; do printf %s "${base58[n]}"; done
}

entropy=$1

priv=$(printf %s "$entropy" | openssl dgst -sha256 | awk '{print $2}')
priv_ec=$(printf %s "302e0201010420${priv}a00706052b8104000a" | xxd -r -p | openssl ec -inform DER 2>/dev/null)

btcPrivHex64=$(echo "$priv_ec" | openssl ec -outform DER 2>/dev/null | tail -c+8 | head -c32 | xxd -p -c 32)
btcPrivHex64Prepared=80${btcPrivHex64}
secondHash=$(
    printf %s "$btcPrivHex64Prepared" |
    xxd -r -p |
    sha256sum -b |
    awk '{print $1}' |
    xxd -r -p |
    sha256sum -b |
    awk '{print $1}'
)
checksumBtcPriv=$(printf %s "$secondHash" | cut -c1-8)
btcPrivWIFBase58=$(encodeBase58 "${btcPrivHex64Prepared}${checksumBtcPriv}")

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

echo "entropy: $entropy"
echo "priv: $priv"
echo "priv WIF: $btcPrivWIFBase58"
echo "pub: $pub"
echo "btc: $address"
