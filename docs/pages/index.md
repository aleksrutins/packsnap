<extends template="layouts/index.html"></extends>

# Packsnap
Packsnap is a reproducible Docker image builder implemented in pure Nix, heavily inspired by [Nixpacks](https://nixpacks.com).

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/aleksrutins/packsnap/badge)](https://flakehub.com/flake/aleksrutins/packsnap)


## Installation
To install it, just add it to your project's Flake inputs:
```nix
{
  # ...
  inputs.packsnap.url = "github:aleksrutins/packsnap";
  # ...
}
```

## Basic Usage
To build a basic app using one of the [supported languages](/reference/supported-languages.html), put a simple `flake.nix` in your project's root:
```nix
{
  description = "My fantastic new containerized project";

  inputs.packsnap.url = "https://flakehub.com/f/aleksrutins/packsnap/*.tar.gz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, packsnap }: flake-utils.lib.eachDefaultSystem (system: {
      packages.container = packsnap.lib.${system}.build { name = "my-image"; path = ./.; };
  });
}
```
Now, you can build it with `nix build .#container`, and then load it into Docker (or Podman) with `docker load < result`.
> **Note:** Unfortunately, at least at the moment, this image will only work if built on Linux.

For a [custom plan](/guides/custom-plans.html), replace `build` with `buildCustomPlan`.
