{ lib
, solc_ver
, solc_sha256
, stdenv
, fetchurl
, autoPatchelfHook
}:

let
  pname = "solc-static";
  version = solc_ver;
  meta = with lib; {
    description = "Static binary of compiler for Ethereum smart contract language Solidity";
    homepage = "https://github.com/ethereum/solidity";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hellwolf ];
    mainProgram = "solc-${solc_ver}";
  };

  inherit (stdenv.hostPlatform) system;
  solc-flavor-base = {
    x86_64-linux = "solc-static-linux";
    x86_64-darwin = "solc-macos";
    aarch64-darwin = "solc-macos-aarch";
  }.${system} or (throw "Unsupported system: ${system}");

  # Fix solc flavor for macos for newer versions.
  solc-flavor =
    if solc-flavor-base == "solc-macos-aarch" && builtins.compareVersions solc_ver "0.8.24" > -1
    then "solc-macos"
    else solc-flavor-base;

  # The official solc binaries for macOS started supporting Apple Silicon with
  # v0.8.24. For earlier versions, the binaries from svm can be used.
  # See https://github.com/alloy-rs/solc-builds
  url =
    if solc-flavor == "solc-macos" || solc-flavor == "solc-static-linux" then
      "https://github.com/ethereum/solidity/releases/download/v${version}/${solc-flavor}"
    else if builtins.compareVersions solc_ver "0.8.5" > -1 then
      "https://github.com/alloy-rs/solc-builds/raw/e4b80d33bc4d015b2fc3583e217fbf248b2014e1/macosx/aarch64/solc-v${version}"
    else throw "Unsupported version ${version} for ${system}";

  solc = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      inherit url;
      sha256 = solc_sha256.${solc-flavor};
    };
    dontUnpack = true;

    nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [ autoPatchelfHook ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp ${src} $out/bin/solc-${version}
      chmod +x $out/bin/solc-${version}

      runHook postInstall
    '';
  };
in
solc
