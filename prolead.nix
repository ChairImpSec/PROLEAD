# prolead.nix
{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gnumake,
  boost186,
  flint,
  python310,
  catch2,
  gcc-arm-embedded,
}:

stdenv.mkDerivation {
  pname = "prolead";
  version = "v3.0.3";

  src = fetchFromGitHub {
    owner = "ChairImpSec";
    repo = "PROLEAD";
    rev = "v3.0.3";
    sha256 = "sha256-VYU/Q22pxjoloZA4J1LdJG1HfHesfxe0enWclwdF6RI=";
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
    (boost186.override {
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
