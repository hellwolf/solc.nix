{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  solc_ver,
  solc_sha256,
  solc-macos-amd64-list,
  ...
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
  solc-flavor =
    {
      x86_64-linux = "solc-static-linux";
      x86_64-darwin = "solc-macos-amd64";
      aarch64-darwin = "solc-macos-aarch64";
    }
      .${system} or (throw "Unsupported system: ${system}");

  # The official solc binaries for macOS started supporting Apple Silicon with
  # v0.8.24. For earlier versions, the binaries from svm can be used.
  # See https://github.com/alloy-rs/solc-builds
  url =
    if solc-flavor == "solc-static-linux" then
      "https://github.com/ethereum/solidity/releases/download/v${version}/solc-static-linux"
    else if solc-flavor == "solc-macos-amd64" then
      "https://binaries.soliditylang.org/macosx-amd64/${solc-macos-amd64-list.releases.${version}}"
    else if solc-flavor == "solc-macos-aarch64" && builtins.compareVersions solc_ver "0.8.5" > -1 then
      "https://github.com/alloy-rs/solc-builds/raw/master/macosx/aarch64/solc-v${version}"
    else
      throw "Unsupported version ${version} for ${system}";
in
if (builtins.hasAttr solc-flavor solc_sha256) then
  (stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      inherit url;
      sha256 = solc_sha256.${solc-flavor};
    };
    dontUnpack = true;

    #nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [ autoPatchelfHook ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp ${src} $out/bin/solc-${version}
      chmod +x $out/bin/solc-${version}

      runHook postInstall
    '';
  })
else
  null
