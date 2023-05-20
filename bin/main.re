open! Core;

module AppId = {
  let qualifier = "com";
  let organization = "rutins";
  let application = "packsnap";
};

let create_build_dir = project_path => {
  module Dirs = Directories.Project_dirs(AppId);
  let dir =
    Filename.concat(
      Option.value(Dirs.cache_dir, ~default=""),
      Filename_unix.realpath(project_path) |> Filename.basename,
    );

  dir;
};

let _ = print_endline(create_build_dir("."));
