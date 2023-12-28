{
  description = "A Deno example for Packsnap";

  inputs.packsnap.url = "../..";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, packsnap }: flake-utils.lib.eachDefaultSystem (system: {
      packages.packsnap-deno = packsnap.lib.${system}.build { name = "packsnap-deno"; path = ./.; };
  });
}
