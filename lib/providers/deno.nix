{ pkgs }:
let plan = import ../plan { inherit pkgs; };

    getStartFile = path:
      builtins.head (builtins.filter (builtins.pathExists) [/./${path}/index.js /./${path}/index.ts]);

    getBuildCmd = path:
      #if builtins.pathExists /./${path}/deps.ts then
      #  "deno cache ${/./${path}/deps.ts}"
      #else
        null;
    
    getStartFileCmd = path:
      let startFile = getStartFile path;
      in if startFile != null then
        "deno run ${startFile}"
      else
        null;

    getStartCmd = path: derivation:
      let denoJSONPath = /./${path}/deno.json;
      in "cd ${derivation} && " + 
        (if builtins.pathExists denoJSONPath then
          let denoJSON = pkgs.lib.importJSON denoJSONPath;
          in if !(isNull (denoJSON.tasks or {}).start) then
            denoJSON.tasks.start
          else getStartFileCmd path
        else getStartFileCmd path);
in
{
  detect = path:
       (builtins.pathExists /./${path}/deno.json)
    || (builtins.pathExists /./${path}/importmap.json)
    || (builtins.length (builtins.filter (builtins.pathExists) [/./${path}/index.ts /./${path}/index.js])) > 0;
  
  plan = path:
    let derivation = pkgs.stdenv.mkDerivation {
      name = "packsnap-build-" + (builtins.baseNameOf path);
      src = path;
      buildPhase = getBuildCmd path;
      installPhase = ''
        cp -r . "$out"
      '';
      buildInputs = [pkgs.deno];
    };
    in plan.buildPlan [] [pkgs.deno derivation] [] (getStartCmd path derivation);
}