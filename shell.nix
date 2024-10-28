{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "prolead-dev";

  nativeBuildInputs = with pkgs; [
    pkg-config
    gnumake
    gcc
  ];
  buildInputs = with pkgs; [
    (boost185.override {
      enablePython = true;
      python = python310;
    })
    flint
    python310
    gcc-arm-embedded
    bear
    catch2
  ];
}
