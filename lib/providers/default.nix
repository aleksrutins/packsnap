{}:
let
  providers = [
    (import ./rust.nix {})
    (import ./node.nix {})
  ];
in with builtins;
{
  planBuild = path:
    head (filter (provider: (provider.detect path)) providers);
}