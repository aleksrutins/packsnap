type t = {
  env: string Util.EnvHash.t;
  packages: Package.t list;
  build_commands: string list;
  run_command: string;
}

let create_plan packages build_commands run_command = {
  env = Util.EnvHash.empty;
  packages;
  build_commands;
  run_command;
}