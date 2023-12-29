{ pkgs }:
let plan = import ../plan { inherit pkgs; };
in {
  detect = path:
    (builtins.pathExists /./${path}/go.mod);
  
  plan = path:
    let derivation = pkgs.stdenv.mkDerivation {
      name = "packsnap-build-" + (builtins.baseNameOf path);
      src = path;
      
      nativeBuildInputs = [pkgs.go];

      configurePhase = ''
      go mod download
      '';

      buildPhase = ''
      # this line removes a bug where value of $HOME is set to a non-writable /homeless-shelter dir (see https://github.com/NixOS/nix/issues/670#issuecomment-1211700127)
      export HOME=$(pwd)
      go build -o packsnap-out
      '';

      installPhase = ''
      mkdir -p $out && cp packsnap-out $out
      '';
    };
    in plan.buildPlan [] [derivation] [] "${derivation}/packsnap-out";
}