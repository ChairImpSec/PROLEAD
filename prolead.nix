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
  version = "v3.0.0-alpha";

  src = fetchFromGitHub {
    owner = "ChairImpSec";
    repo = "PROLEAD";
    rev = "v3.0.0-alpha";
    sha256 = "1jcdpms8nbva7d8f8if0axq1aih0j8bvmg8i7cwb5n4p9fydx5vb";
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
