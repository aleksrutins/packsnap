{ nixpkgs ? (import ../sources.nix).nixpkgs
, pkgs ? import nixpkgs {} }:
{
  buildPlan = variables: contents: libraries: runCmd:
    with builtins;
    {
      inherit contents;
      config = {
        Env = variables;
        Cmd = runCmd;
      };
    };
}