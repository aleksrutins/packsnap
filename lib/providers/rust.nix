{ sources ? import ../sources.nix
, pkgs ? import sources.nixpkgs { overlays = [ (import sources."rust.nix") ]; }
}:
let plan = import ../plan {};
    parseCargoToml = path:
      pkgs.lib.importTOML /./${path}/Cargo.toml;
    getStartCmd = path:
      (parseCargoToml path).package.name or "";
in {
  detect = path:
    builtins.pathExists (/./${path}/Cargo.toml);
  plan = path:
    let
      derivation = pkgs.rust-nix.buildPackage { root = path; buildInputs = [pkgs.libiconv]; };
    in
      plan.buildPlan [] [derivation] [] (getStartCmd path);
}