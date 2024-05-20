{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchurl,
  solc-macos-amd64-list,
  ...
}:

builtins.foldl' (
  all_binaries: binary:
  let
    pname = "solc_" + (builtins.replaceStrings [ "." ] [ "_" ] binary.version);
    maybeSolc = (import ./mk-solc-static-pkg.nix) {
      inherit lib;
      inherit stdenv;
      inherit autoPatchelfHook;
      inherit fetchurl;
      inherit solc-macos-amd64-list;
      solc_ver = binary.version;
      solc_sha256 = binary.sha256;
    };
  in
  if maybeSolc != null then all_binaries // { "${pname}" = maybeSolc; } else all_binaries
) { } (import ./solc-listing.nix)
