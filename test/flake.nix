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
          devShells.default =
            with pkgs;
            mkShell {
              buildInputs =
                [
                  solc_0_8_26
                  (solc.mkDefault pkgs solc_0_8_26)
                ]
                ++ (
                  if system == "x86_64-linux" then
                    [
                      solc_0_4_11
                      solc_0_7_6
                    ]
                  else if system == "x86_64-darwin" then
                    [
                      solc_0_4_11
                      solc_0_7_6
                    ]
                  else if system == "aarch64-darwin" then
                    [ solc_0_8_5 ]
                  else
                    throw "unknown system"
                );
            };
        }
      );
}
