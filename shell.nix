{ pkgs ? import <nixpkgs> {} }:

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
  ];
}
