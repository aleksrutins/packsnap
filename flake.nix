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
                pkgs.nodejs
                pkgs.nodePackages.esy
              ];
              src = self;
              buildPhase = "esy build";
              installPhase = "mkdir -p $out/bin; install -t $out/bin/packsnap _esy/default/build/install/default/bin/packsnap.exe";
            };
        };
      }
    );
}
