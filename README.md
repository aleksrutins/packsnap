# Packsnap
Packsnap is a pure-Nix library (based on flakes) for building Docker images with little to no configuration. Heavily inspired by [Nixpacks](https://nixpacks.com).

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/aleksrutins/packsnap/badge)](https://flakehub.com/flake/aleksrutins/packsnap)

## Usage
To use it, just add a `flake.nix` to your project (using whatever output name you want, `my-image` is just an example):
```nix
{
  description = "My fantastic new containerized project";

  inputs.packsnap.url = "https://flakehub.com/f/aleksrutins/packsnap/*.tar.gz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, packsnap }: flake-utils.lib.eachDefaultSystem (system: {
      packages.my-image = packsnap.lib.${system}.build { name = "my-image"; path = ./.; };
  });
}
```

and build it with:
```
$ nix build .#my-image
$ docker load < result
```
