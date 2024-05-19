{
  lib,
  callPackage,
  solc-macos-amd64-list,
  ...
}:

lib.foldr (
  binary: all_binaries:
  let
    pname = "solc_" + (builtins.replaceStrings [ "." ] [ "_" ] binary.version);
    maybeSolc = callPackage (import ./mk-solc-static-pkg.nix) {
      solc_ver = binary.version;
      solc_sha256 = binary.sha256;
      inherit solc-macos-amd64-list;
    };
  in
  if maybeSolc != null then all_binaries // { "${pname}" = maybeSolc; } else all_binaries
) { } (import ./solc-listing.nix)
