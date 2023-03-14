{
  description = "A very basic flake";

  inputs.solc.url = "..";

  outputs = { self, nixpkgs, solc }: let 
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        solc.overlay
      ];
    };
  in {
    devShell.x86_64-linux = with pkgs; mkShell {
      buildInputs = [ solc_0_8_19 ];
    };
  };
}
