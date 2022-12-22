{}:
let
  providers = [
    (import ./rust.nix {})
  ];
in with builtins;
{
  planBuild = path:
    head (filter (provider: (provider.detect path)) providers);
}