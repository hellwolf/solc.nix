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
  solc-flavor = {
    x86_64-linux = "solc-static-linux";
    x86_64-darwin = "solc-macos";
    aarch64-darwin = "solc-macos";
  }.${system} or (throw "Unsupported system: ${system}");

  solc = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/ethereum/solidity/releases/download/v${version}/${solc-flavor}";
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
