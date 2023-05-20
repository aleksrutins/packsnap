open! Core;
open AppInfo;
open Cmdliner;

let create_build_dir = project_path => {
  module Dirs = Directories.Project_dirs(AppId);
  let dir =
    Filename.concat(
      Option.value(Dirs.cache_dir, ~default=""),
      Filename_unix.realpath(project_path) |> Filename.basename,
    );

  dir;
};

let cmd =
  Cmd.group(
    Cmd.info("packsnap"),
    [Cmd.v(Cmd.info("build"), Build.build_t)],
  );

exit(Cmd.eval(cmd));
