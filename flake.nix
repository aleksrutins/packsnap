{
  description = "A reproducible container build system";
  
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.vls.url = "github:aleksrutins/nix-vls";

  outputs = { self, nixpkgs, flake-utils, vls }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree {
          default =
            with import nixpkgs {system = system; };
            stdenv.mkDerivation {
              name = "packsnap";
              nativeBuildInputs = [
                pkgs.gcc
                pkgs.vala
                pkgs.pkg-config
                pkgs.meson
                pkgs.ninja
              ];
              buildInputs = [
                pkgs.glib
              ];
              src = self;
            };
        };
        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              vls.packages.${system}.default
            ];
            buildInputs = [
              packages.default
            ];
          };
        };
      }
    );
}
