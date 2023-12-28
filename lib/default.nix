{ nixpkgs
, pkgs ? import nixpkgs {}
, misc ? import ./misc.nix {}
, naersk
, npmlock2nix }:
let 
  providers = import ./providers { inherit pkgs naersk npmlock2nix; };
  plan = import ./plan { inherit pkgs; };
in {
  build = ({ name ? "packsnap-image", tag ? "latest", path }:
    let provider = providers.planBuild path;
    in pkgs.dockerTools.buildImage ((provider.plan path) // { inherit name tag; })
  );
  buildCustomPlan = ({ name ? "packsnap-image", tag ? "latest", variables ? [], contents, libraries ? [], start }:
    pkgs.dockerTools.buildImage ((plan.buildPlan variables contents libraries start) // { inherit name tag; }));
}