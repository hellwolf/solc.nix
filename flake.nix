{
  description = "Providing assorted versions of solidity compilers (solc)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    solc-macos-amd64-list-json = {
      # Go to https://github.com/ethereum/solc-bin/blob/gh-pages/macosx-amd64/list.json to obtain a revision
      url = "file+https://github.com/ethereum/solc-bin/raw/f743ca7/macosx-amd64/list.json";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      solc-macos-amd64-list-json,
    }:
    let
      solc-macos-amd64-list = builtins.fromJSON (builtins.readFile solc-macos-amd64-list-json);
      solc-pkgs-overlay =
        final: prev: import ./mk-solc-pkgs.nix (prev // { inherit solc-macos-amd64-list; });
    in
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ solc-pkgs-overlay ];
          };
        in
        {
          # default shell with the latest solc compiler
          devShells.default = pkgs.mkShell { buildInputs = [ pkgs.solc_0_8_19 ]; };
        }
      )
    // {
      # the overlay for nixpkgs
      overlay = solc-pkgs-overlay;

      # make a package with the symlink 'solc' to the selected solc
      mkDefault =
        pkgs: solc-selected:
        pkgs.runCommand "solc-default" { }
          "mkdir -p $out/bin && ln -s ${pkgs.lib.getExe solc-selected} $out/bin/solc";
    };
}
