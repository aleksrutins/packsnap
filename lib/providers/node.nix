{ sources ? import ../sources.nix
, pkgs ? import sources.nixpkgs {}
, npmlock2nix ? pkgs.callPackage sources.npmlock2nix {}
}:
let plan = import ../plan {};

    getStartCmd = path: derivation:
      let packageJson = pkgs.lib.importJSON /./${path}/package.json;
      in
        "cd ${derivation} && " +
          (if !(isNull ((packageJson.scripts or {}).start or null)) then
            "${pkgs.nodejs}/bin/npm start"
          else if !(isNull packageJson.main) then
            "${pkgs.nodejs}/bin/node ${packageJson.main}"
          else
            "${pkgs.nodejs}/bin/node index.js");

    getBuildCmds = path:
      let packageJson = pkgs.lib.importJSON /./${path}/package.json;
      in
        if !(isNull ((packageJson.scripts or {}).build or null)) then
          ["npm run build"]
        else
          [];

in with builtins;
{
  detect = path:
    pathExists /./${path}/package.json;
  plan = path:
    let
      derivation = npmlock2nix.v1.build {
        src = path;
        installPhase = "cp -r . $out";
        buildCommands = getBuildCmds path;
      };
    in
      plan.buildPlan [] [pkgs.nodejs derivation] [] (getStartCmd path derivation);
}