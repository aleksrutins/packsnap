open Packsnap.Util

type t = {
  env: string EnvHash.t;
  packages: Package.t list;
  build_commands: string list;
  run_command: string;
}

let create_plan packages build_commands run_command = {
  env = EnvHash.empty;
  packages;
  build_commands;
  run_command;
}