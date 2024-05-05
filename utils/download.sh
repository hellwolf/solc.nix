#!/usr/bin/env bash

macos_versions=$(mktemp)
curl https://binaries.soliditylang.org/macosx-amd64/list.json >"$macos_versions"

T=$(dirname "$0")/..
[[ -e "$T/bin" ]] || { echo "Symlink or create a top-level bin folder" && exit 1; }

list_all_versions() {
    for i in $(seq 11 26); do echo 0.4."$i"; done
    for i in $(seq  0 17); do echo 0.5."$i"; done
    for i in $(seq  0  9); do echo 0.6."$i"; done
    for i in $(seq  0  6); do echo 0.7."$i"; done
    for i in $(seq  0 25); do echo 0.8."$i"; done
}

download_one_version() {
    v=$1

    mkdir -p "$T/bin/static-linux"
    u=https://github.com/ethereum/solidity/releases/download/v$v/solc-static-linux
    o=$T/bin/static-linux/solc-$v
    # use -Nc for timestamping check and avoid redownloading
    # not all versions contain a macos binary, rm failed download
    wget -Nc "$u" -O "$o" || rm -f "$o";

    mkdir -p "$T/bin/macos"
    u=https://binaries.soliditylang.org/macosx-amd64/$(jq -r ".releases.\"$1\"" "$macos_versions")
    o=$T/bin/macos/solc-$v
    # use -Nc for timestamping check and avoid redownloading
    # not all versions contain a macos binary, rm failed download
    wget -Nc "$u" -O "$o" || rm -f "$o";

    # second try download alloy macos binaries
    mkdir -p "$T/bin/macos-aarch"
    u=https://github.com/alloy-rs/solc-builds/raw/e4b80d33bc4d015b2fc3583e217fbf248b2014e1/macosx/aarch64/solc-v$v
    o=$T/bin/macos-aarch/solc-$v
    # use -Nc for timestamping check and avoid redownloading
    # not all versions contain a macos binary, rm failed download
    wget -Nc "$u" -O "$o" || rm -f "$o";
}

download_all_versions() {
    for v in $(list_all_versions); do
        download_one_version "$v"
    done
}

if [[ "$1" == "" ]]; then
    echo "Usage: $0 all | version"
elif [[ "$1" == all ]]; then
    download_all_versions
else
    download_one_version "$1"
fi
