{ nixpkgs ? (import ./sources.nix).nixpkgs
, pkgs ? import nixpkgs {}
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
, misc ? import ./misc.nix {}
, packsnap }:
let providers = import ./providers {};
in rec {
  build = ({ name ? "packsnap-image", path }:
    let provider = providers.planBuild path;
    in pkgs.dockerTools.buildImage ((provider.plan path) // { name = "packsnap-image"; tag = "latest"; })
  );
}