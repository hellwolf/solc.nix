{
  description = "Providing assorted versions of solidity compilers (solc)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  let
    mk-solc-pkgs = import ./mk-solc-pkgs.nix;
  in flake-utils.lib.eachSystem [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
      solcPkgs = mk-solc-pkgs pkgs;
    in {
      # assorted solc packages
      packages = solcPkgs;

      # default shell with the latest solc compiler
      devShells.default = pkgs.mkShell {
        buildInputs = [ solcPkgs.solc_0_8_19 ];
      };
      # shell with all solc compilers
      devShells.all = pkgs.mkShell {
        buildInputs = builtins.attrValues solcPkgs;
      };
  }) // {
    # the overlay for nixpkgs
    overlay = final: prev: mk-solc-pkgs prev;

    # make a package with the symlink 'solc' to the selected solc
    mkDefault = pkgs : solc-selected: pkgs.runCommand "solc-default" {}
      "mkdir -p $out/bin && ln -s ${pkgs.lib.getExe solc-selected} $out/bin/solc";
  };
}
