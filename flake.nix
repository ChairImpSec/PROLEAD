{
  description = "PROLEAD";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        let
          prolead = pkgs.callPackage ./prolead.nix;
          gdstk = pkgs.callPackage ./gdstk.nix { };
        in
        with pkgs;
        rec {
          packages.prolead =
            (prolead {
              inherit gdstk;
              withPython = python312;
            }).overrideAttrs
              (old: {
                src = ./.;
                version = "dev";
                buildInputs = old.buildInputs ++ [
                  qhull
                  zlib
                ];
              });
          packages.prolead_31 = prolead { };
          packages.default = packages.prolead;

          devShells.default = callPackage ./shell.nix {
            inherit gdstk;
          };
          formatter = nixfmt-tree;
        };
    };
}
