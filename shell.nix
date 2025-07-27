{ pkgs ? import <nixpkgs> {} }:


let gdstk = pkgs.callPackage ./gdstk.nix { }; in pkgs.mkShell {
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

  shellHook=''
    export PROLEAD="$(pwd)/release/PROLEAD" && export PROLEAD_LIB="$(pwd)/libs"'';
}
