{}:
let
  providers = [
    (import ./rust.nix {})
    (import ./node.nix {})
    # Deno MUST come after Node!
    (import ./deno.nix {})
  ];
in with builtins;
{
  planBuild = path:
    head (filter (provider: (provider.detect path)) providers);
}