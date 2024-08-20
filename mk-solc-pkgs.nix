pkgs:
{ solc-macos-amd64-list }:

let
  solcPackages = builtins.foldl' (
    allBinaries: binary:
    let
      pname = "solc_" + (builtins.replaceStrings [ "." ] [ "_" ] binary.version);
      maybeSolc = import ./mk-solc-static-pkg.nix (
        pkgs
        // {
          solc_ver = binary.version;
          solc_sha256 = binary.sha256;
          inherit solc-macos-amd64-list;
        }
      );
    in
    if maybeSolc != null then allBinaries // { "${pname}" = maybeSolc; } else allBinaries
  ) { } (import ./solc-listing.nix);
in
solcPackages // { inherit solcPackages; }
