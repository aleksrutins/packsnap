{
  description = "A reproducible container build system";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
        stuff = import ./. { inherit nixpkgs pkgs; };
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          packsnap = stuff.packsnap;
          default = stuff.packsnap;
        };
        devShells = flake-utils.lib.flattenTree {
          default = pkgs.mkShell {
            buildInputs = [
              packages.default
            ];
          };
        };
        lib = stuff.lib;
      }
    );
 }