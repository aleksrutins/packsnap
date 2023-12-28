{ pkgs }:
{
  buildPlan = variables: contents: libraries: runCmd:
    with builtins;
    {
      copyToRoot = pkgs.buildEnv {
        name = "packsnap-image";
        paths = concatLists [contents [pkgs.bash]];
      };
      config = {
        Env = variables;
        Cmd = ["${pkgs.bash}/bin/bash" "-c" runCmd];
      };
    };
}