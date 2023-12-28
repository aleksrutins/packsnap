{
  description = "A custom plan example for Packsnap";

  inputs.packsnap.url = "../..";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, packsnap }: flake-utils.lib.eachDefaultSystem (system:
      let pkgs = (import nixpkgs) { inherit system; };
      in {
        packages.packsnap-custom-plan = packsnap.lib.${system}.buildCustomPlan { 
          name = "packsnap-custom-plan";
          contents = [
            (pkgs.stdenv.mkDerivation {
              name = "packsnap-custom-plan";
              inherit system;
              
              src = ./.;
              nativeBuildInputs = [
                pkgs.gcc
                pkgs.pkg-config
                pkgs.meson
                pkgs.ninja
              ];
            })
          ];
          start = "packsnap-custom-plan";
        };
      }
  );
}
