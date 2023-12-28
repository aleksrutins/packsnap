{ pkgs, naersk }:
let plan = import ../plan { inherit pkgs; };
    parseCargoToml = path:
      pkgs.lib.importTOML /./${path}/Cargo.toml;
    getStartCmd = path:
      (parseCargoToml path).package.name or "";
in {
  detect = path:
    builtins.pathExists (/./${path}/Cargo.toml);
  plan = path:
    let
      derivation = naersk.buildPackage { root = path; buildInputs = [pkgs.libiconv]; };
    in
      plan.buildPlan [] [derivation] [] (getStartCmd path);
}