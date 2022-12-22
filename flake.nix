{
  description = "A reproducible container build system";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "packsnap";
              nativeBuildInputs = [
                pkgs.gcc
                pkgs.pkg-config
                pkgs.meson
                pkgs.ninja
              ];
              src = self;
            };
        };
        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
            buildInputs = [
              packages.default
            ];
          };
        };
        lib = import ./lib { inherit nixpkgs; };
      }
    );
 }