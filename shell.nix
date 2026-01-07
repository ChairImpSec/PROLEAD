{
  pkgs ? import <nixpkgs> { },
  gdstk ? pkgs.callPackage ./gdstk.nix { },
}:
pkgs.mkShell {
  name = "prolead-dev";

  nativeBuildInputs = with pkgs; [
    pkg-config
    gnumake
    gcc
  ];
  buildInputs = with pkgs; [
    (boost186.override {
      enablePython = true;
      python = python312;
    })
    flint
    python312
    gcc-arm-embedded
    bear
    catch2
    # ---- gdstk----
    qhull
    zlib
    clipper
    gdstk
  ];

  shellHook = ''
    export PROLEAD_RELEASE="$(pwd)/release/"
    export PROLEAD_LIB="$(pwd)/libs"
    alias prolead="$(pwd)/release/PROLEAD"
  '';
}
