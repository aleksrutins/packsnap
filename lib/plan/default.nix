{ nixpkgs ? (import ../sources.nix).nixpkgs
, pkgs ? import nixpkgs {} }:
{
  buildPlan = variables: contents: libraries: runCmd:
    with builtins;
    {
      contents = concatLists [contents [pkgs.bash]];
      config = {
        Env = variables;
        Cmd = ["${pkgs.bash}/bin/bash" "-c" runCmd];
      };
    };
}