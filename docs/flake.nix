{
  inputs = {
    packsnap.url = "../.";
    cheetah.url = "github:aleksrutins/cheetah";
    cheetah.inputs.packsnap.follows = "packsnap";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, cheetah }:
    let config = {
      always_hydrate = true;
    };
    in utils.lib.eachDefaultSystem (system: {
      packages =
        let pkgs = (import nixpkgs) { inherit system; };
        in rec {
          default = (cheetah.buildSite.${system} ./. {
            name = "packsnap-docs";
            inherit config;
          });

          container = cheetah.createContainer.${system} {
            inherit pkgs;
            site = default;
            options = {
              name = "packsnap-docs";
              inherit config;
            };
          };
        };

      devShells.default = (cheetah.createDevShell.${system} { inherit config; });
    });
}