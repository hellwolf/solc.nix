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
    homepage = "https://github.com/argotorg/solidity";
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
    # We musnt' throw here, since nixos-rebuild seems not liking it.
    .${system} or "unsupported-system";

  # The official solc binaries for macOS started supporting Apple Silicon with
  # v0.8.24. For earlier versions, the binaries from svm can be used.
  # See https://github.com/alloy-rs/solc-builds
  macosUniversalBuildUrl = "https://binaries.soliditylang.org/macosx-amd64/${
    solc-macos-amd64-list.releases.${version}
  }";

  url =
    if solc-flavor == "solc-static-linux" then
      "https://github.com/argotorg/solidity/releases/download/v${version}/solc-static-linux"
    else if solc-flavor == "solc-macos-amd64" then
      macosUniversalBuildUrl
    else if solc-flavor == "solc-macos-aarch64" && builtins.compareVersions solc_ver "0.8.5" > -1 then
      if builtins.compareVersions solc_ver "0.8.24" == -1 then
        "https://github.com/alloy-rs/solc-builds/raw/master/macosx/aarch64/solc-v${version}"
      else
        macosUniversalBuildUrl
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

    nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [ autoPatchelfHook ];

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
