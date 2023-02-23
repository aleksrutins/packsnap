{ pkgs ? import <nixpkgs> {} }:
let stuff = import ./. { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = [ stuff.packsnap ];
}