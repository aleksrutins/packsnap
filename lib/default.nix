{ nixpkgs
, pkgs ? import nixpkgs {}
, misc ? import ./misc.nix {}
, naersk
, npmlock2nix }:
let providers = import ./providers { inherit pkgs naersk npmlock2nix; };
in {
  build = ({ name ? "packsnap-image", path }:
    let provider = providers.planBuild path;
    in pkgs.dockerTools.buildImage ((provider.plan path) // { name = name; tag = "latest"; })
  );
}