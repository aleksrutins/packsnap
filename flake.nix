{
  description = "A reproducible container build system";
  
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
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
                pkgs.glib
              ];
              src = self;
            };
        };
      }
    );
}
