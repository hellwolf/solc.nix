{ solc-macos-amd64-list
} :

p : p.lib.foldr (a: b: let
  pname = "solc_" + (builtins.replaceStrings ["."] ["_"] a.version);
in b // {
  "${pname}" = p.callPackage (import ./mk-solc-static.nix) {
    solc_ver = a.version;
    solc_sha256 = a.sha256;
    inherit solc-macos-amd64-list;
  };
}) {} (import ./solc-listing.nix)
