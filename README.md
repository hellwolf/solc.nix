A Solidity Compilers Collection in Nix
======================================

This Nix flake provides a collection of static-linux and macos builds of [solidity compilers
(solc)](https://github.com/ethereum/solidity/) as [an overlay](https://nixos.wiki/wiki/Overlays).

# Usage

**Using Nix Flake**

The following flake will make solc 0.4.26, 0.7.6 and 0.8.19 available for development.

Additionally, a convenient function `mkDefault` is provided to create a symlink to a selected version of solc.

```nix
{
  inputs = {
    solc = {
      url = "github:hellwolf/solc.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, solc }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        solc.overlay
      ];
    };
  in {
    devShell.x86_64-linux = with pkgs; mkShell {
      buildInputs = [
        solc_0_4_26
        solc_0_7_6
        solc_0_8_19
        (solc.mkDefault pkgs solc_0_8_19)
      ];
    };
  };
}
```

For example, they should be available through the development shell.

```
$ nix develop .

$ solc-0.4.26 --version
solc, the solidity compiler commandline interface
Version: 0.4.26+commit.4563c3fc.Linux.g++

$ solc-0.7.6 --version
solc, the solidity compiler commandline interface
Version: 0.7.6+commit.7338295f.Linux.g++

$ solc-0.8.19 --version
solc, the solidity compiler commandline interface
Version: 0.8.19+commit.7dd6d404.Linux.g++
```

**Using Nix Shell**

You can also use `nix shell` directly without having to write a nix flake for a project.

```
# Solc packages are listed as "solc_{version}" directly,
nix shell github:hellwolf/solc.nix#solc_0_4_26 github:hellwolf/solc.nix#solc_0_8_19
# and collected under "solcPackages" too.
nix shell github:hellwolf/solc.nix#solcPackages.solc_0_4_26
```

# Contribute

The author will make his best effort of keeping this repo up to date.

But if you find it's lagging behind, here are the utility scripts to help yourself out:

**./utils/download.sh**

1) Create a bin folder at the top level of the project.
2) Download all versions of solc: `./utils/download.sh all`
3) Download a specific version of solc: `./utils/download.sh 0.8.19`

**./utils/create-listing.sh**

This will override the `solc-listing.nix` file.

Pull requests are welcome!
