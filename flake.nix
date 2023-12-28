{
  description = "A reproducible container build system";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    npmlock2nix = {
      url = "github:nix-community/npmlock2nix";
      flake = false;
    };
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, npmlock2nix, naersk }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = (import nixpkgs) {
          inherit system;
          overlays = [
            (final: prev: {
              npmlock2nix = import npmlock2nix { pkgs = prev; };
            })
          ];
        };
        naersk' = pkgs.callPackage naersk {};
        npmlock2nix' = pkgs.npmlock2nix;

      in
      {
        lib = import ./lib {
          inherit nixpkgs pkgs;
          naersk = naersk';
          npmlock2nix = npmlock2nix';
        };
      }
    );
 }