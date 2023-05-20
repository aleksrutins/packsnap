open Packsnap.Util

type t = {
  base_image: string;
  env: string EnvHash.t;
  packages: Package.t list;
  build_commands: string list;
  run_command: string;
}

let create_plan base_image packages build_commands run_command = {
  base_image;
  env = EnvHash.empty;
  packages;
  build_commands;
  run_command;
}