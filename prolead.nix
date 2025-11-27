{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gnumake,
  boost186,
  flint,
  python310,
  python312,
  withPython ? python310,
  gdstk ? null,
  catch2,
  gcc-arm-embedded,
  srcHash ? "sha256-LIqxlFaAeHrORV93vavuy0wWemEIJpb7HBuaLMfzzT8=",
}:
stdenv.mkDerivation rec {
  pname = "prolead";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ChairImpSec";
    repo = "PROLEAD";
    rev = "v${version}";
    hash = srcHash;
  };

  # Required for building
  nativeBuildInputs = [
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
      python = withPython;
    })
    flint
    withPython
    gcc-arm-embedded
  ]
  ++ (lib.optional (gdstk != null) gdstk);

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp release/PROLEAD $out/bin
    runHook postInstall
  '';

  meta = {
    description = "PROLEAD - A Probing-Based Leakage Detection Tool for Hardware and Software + FIESTA - Fault Injection Evaluation with Statistical Analysis";
    homepage = "https://github.com/ChairImpSec/PROLEAD";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "PROLEAD";
    platforms = lib.platforms.all;
  };
}
