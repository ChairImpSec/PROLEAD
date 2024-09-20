# prolead.nix
{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gnumake,
  boost185,
  flint,
  python310,
  catch2,
  gcc-arm-embedded,
}:

stdenv.mkDerivation {
  pname = "prolead";
  version = "v3.0.3-alpha";

  src = fetchFromGitHub {
    owner = "ChairImpSec";
    repo = "PROLEAD";
    rev = "v3.0.3-alpha";
    sha256 = "2nfUc9q/DnCsme+90wtzHWRFHsSOXQ0OHj/AqhgoerI=";
  };

  # Required for building
  nativeBuildInputs =  [
    pkg-config
    gnumake
  ];
  nativeCheckInputs = [
    catch2
  ];

  # Required at runtime
  buildInputs = [
    (boost185.override {
      enablePython = true;
      python = python310;
    })
    flint
    python310
    gcc-arm-embedded
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp release/PROLEAD $out/bin
    runHook postInstall
  '';
}
