{ pkgs, naersk, npmlock2nix }:
let
  providers = [
    (import ./rust.nix { inherit pkgs naersk; })
    (import ./node.nix { inherit pkgs npmlock2nix; })
    # Deno MUST come after Node!
    (import ./deno.nix { inherit pkgs; })
  ];
in with builtins;
{
  planBuild = path:
    head (filter (provider: (provider.detect path)) providers);
}