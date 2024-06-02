{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    solc = {
      url = "path:../.";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      solc,
    }:
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
            overlays = [ solc.overlay ];
          };
        in
        {
          devShell.default =
            with pkgs;
            mkShell {
              buildInputs = [
                solc_0_7_6
                solc_0_8_23
                (solc.mkDefault pkgs solc_0_8_25)
              ];
            };
        }
      );
}
