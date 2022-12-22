{ nixpkgs
, pkgs ? import nixpkgs {}
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
, packsnap }:
rec {
  build = ({ name ? "packsnap-image" }:
    pkgs.dockerTools.buildImage {
      inherit name;
      config = {
        Cmd = [ "${pkgsLinux.hello}/bin/hello" ];
      };
    }
  );
}