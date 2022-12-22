let
  providers = [
    import ./node.nix
  ];
in
{
  planBuild = path:
    head (filter (provider: (provider.detect path)) providers);
}