{
  description = "Providing assorted versions of solidity compilers (solc)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    solc-macos-amd64-list-json = {
      url = "https://binaries.soliditylang.org/macosx-amd64/list.json";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      solc-macos-amd64-list-json,
      ...
    }:
    let
      solc-macos-amd64-list = builtins.fromJSON (builtins.readFile solc-macos-amd64-list-json);
      mk-solc-pkgs =
        {
          lib,
          stdenv,
          fetchurl,
          autoPatchelfHook,
        }:
        import ./mk-solc-pkgs.nix {
          inherit
            solc-macos-amd64-list
            lib
            stdenv
            fetchurl
            autoPatchelfHook
            ;
        };
    in
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
      ]
      (
        system:
        let
          source-solc-0_8_23 = pkgs.callPackage ./solc-from-source.nix { };

          pkgs = import nixpkgs { inherit system; };
          solcPkgs = mk-solc-pkgs {
            inherit (pkgs)
              lib
              stdenv
              fetchurl
              autoPatchelfHook
              ;
          };
          default =
            if (builtins.hasAttr "solc_0_8_23" solcPkgs) then solcPkgs.solc_0_8_23 else source-solc-0_8_23;
        in
        {
          # assorted solc packages
          packages = solcPkgs // {
            inherit default;
            solc = default;
          };
          formatter = pkgs.nixfmt-rfc-style;

          # default shell with the latest solc compiler
          devShells.default = pkgs.mkShell { buildInputs = [ default ]; };
          # shell with all solc compilers
          devShells.all = pkgs.mkShell { buildInputs = builtins.attrValues solcPkgs; };
        }
      )
    // {
      # the overlay for nixpkgs
      overlays.default =
        final: prev:
        prev
        // (mk-solc-pkgs {
          inherit (prev)
            lib
            stdenv
            fetchurl
            autoPatchelfHook
            ;
        });

      # make a package with the symlink 'solc' to the selected solc
      lib.mkDefault =
        pkgs: solc-selected:
        pkgs.runCommand "solc-default" { }
          "mkdir -p $out/bin && ln -s ${pkgs.lib.getExe solc-selected} $out/bin/solc";
    };
}
