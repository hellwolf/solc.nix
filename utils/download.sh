#! /usr/bin/env nix-shell
#! nix-shell -i bash -p semver-tool

macos_versions=$(mktemp)
curl https://binaries.soliditylang.org/macosx-amd64/list.json >"$macos_versions"

T=$(dirname "$0")/..
[[ -e "$T/bin" ]] || { echo "Symlink or create a top-level bin folder" && exit 1; }

list_all_versions() {
    for i in $(seq 11 26); do echo 0.4."$i"; done
    for i in $(seq  0 17); do echo 0.5."$i"; done
    for i in $(seq  0 12); do echo 0.6."$i"; done
    for i in $(seq  0  6); do echo 0.7."$i"; done
    for i in $(seq  0 27); do echo 0.8."$i"; done
}

run_wget() {
    u=$1
    o=$2

    # use -Nc for timestamping check and avoid redownloading
    # not all versions contain a macos binary, rm failed download
    wget -Nc "$u" -O "$o" || rm -f "$o";
}

download_one_version() {
    v=$1

    mkdir -p "$T/bin/static-linux"
    run_wget \
        https://github.com/ethereum/solidity/releases/download/v"$v"/solc-static-linux \
        "$T"/bin/static-linux/solc-"$v"

    mkdir -p "$T/bin/macos-amd64"
    run_wget \
        https://binaries.soliditylang.org/macosx-amd64/$(jq -r ".releases.\"$1\"" "$macos_versions") \
        "$T"/bin/macos-amd64/solc-"$v"

    mkdir -p "$T/bin/macos-aarch64"
    if [ "$(semver compare $v 0.8.23)" == 1 ]; then
        # starting from 0.8.24, official solidity distribution started to provide universal builds
        # references:
        # - https://github.com/ethereum/solidity/issues/14813
        # - https://github.com/alloy-rs/solc-builds/issues/13
        ln -s ../macos-amd64/solc-"$v" "$T"/bin/macos-aarch64/solc-"$v"
    else
        run_wget \
            https://github.com/alloy-rs/solc-builds/raw/master/macosx/aarch64/solc-v"$v" \
            "$T"/bin/macos-aarch64/solc-"$v"
    fi
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
