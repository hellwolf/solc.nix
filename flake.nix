{
  description = "Providing asorted versions of solc compilers.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  let
    solc-compilers = import ./solc-compilers.nix;
  in flake-utils.lib.eachSystem [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in rec {
      packages = solc-compilers pkgs;
      # latest solc compiler
      devShells.default = pkgs.mkShell {
        buildInputs = [ packages.solc_0_8_19 ]; 
      };
      # all solc compilers
      devShells.all = pkgs.mkShell {
        buildInputs = builtins.attrValues packages;
      };
  }) // {
    overlay = final: prev: solc-compilers prev;
  };
}
