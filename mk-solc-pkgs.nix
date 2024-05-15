{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  solc-macos-amd64-list,
}:
lib.foldr (
  binary: all_binaries:
  let
    pname = "solc_" + (builtins.replaceStrings [ "." ] [ "_" ] binary.version);
    mayBePackage = (import ./mk-solc-static.nix) {
      solc_ver = binary.version;
      solc_sha256 = binary.sha256;
      inherit
        lib
        stdenv
        fetchurl
        autoPatchelfHook
        ;
      inherit solc-macos-amd64-list;
    };
  in
  if mayBePackage != null then all_binaries // { "${pname}" = mayBePackage; } else all_binaries
) { } (import ./solc-listing.nix)
