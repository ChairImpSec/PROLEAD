{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "prolead-dev";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    gnumake
    (boost185.override {
        enablePython = true;
        python = python310;
    })
    flint
    git
    python310
    catch2
    heaptrack
    flamegraph
    gcc-arm-embedded
  ];
}
