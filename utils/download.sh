#!/usr/bin/env bash

T=$(dirname "$0")/..
[[ -e "$T/bin" ]] || { echo "Symlink or create a top-level bin folder" && exit 1; }

list_all_versions() {
    for i in $(seq 11 26); do echo 0.4."$i"; done
    for i in $(seq  0 17); do echo 0.5."$i"; done
    for i in $(seq  0  9); do echo 0.6."$i"; done
    for i in $(seq  0  6); do echo 0.7."$i"; done
    for i in $(seq  0 19); do echo 0.8."$i"; done
}

download_one_version() {
    v=$1
    for j in static-linux macos; do
        u=https://github.com/ethereum/solidity/releases/download/v$v/solc-$j
        o=$T/bin/$j/solc-$v
        # use -Nc for timestamping check and avoid redownloading
        # not all versions contain a macos binary, rm failed download
        wget -Nc "$u" -O "$o" || rm -f "$o";
    done
}

download_all_versions() {
    for v in $(list_all_versions); do
        download_one_version "$v"
    done
}

if [[ "$1" == all ]]; then
    download_all_versions
else
    download_one_version "$1"
fi
