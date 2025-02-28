# prolead.nix
{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gnumake,
  boost186,
  flint,
  python312,
  catch2,
  gcc-arm-embedded,
}:

stdenv.mkDerivation {
  pname = "prolead";
  version = "v3.1.0";

  src = fetchFromGitHub {
    owner = "ChairImpSec";
    repo = "PROLEAD";
    rev = "v3.1.0";
    sha256 = "sha256-LIqxlFaAeHrORV93vavuy0wWemEIJpb7HBuaLMfzzT8=";
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
      python = python312;
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
