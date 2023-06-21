{ nixpkgs ? import <nixpkgs>
, pkgs ? import <nixpkgs> { } }:
rec {
  packsnap = pkgs.stdenv.mkDerivation {
    name = "packsnap";
    nativeBuildInputs = [
      pkgs.gcc
      pkgs.pkg-config
      pkgs.meson
      pkgs.ninja
    ];
    src = ./.;
  };
  lib = import ./lib { inherit nixpkgs pkgs packsnap; };
}