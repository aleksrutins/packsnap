open! Core;
open Cmdliner;
open AppInfo;
open Option;
open Packsnap;

let get_out_dir = directory => {
  let filename = Filename.basename(Filename_unix.realpath(directory));
  let out_filename =
    Dirs.cache_dir >>| Filename.concat(_, filename) |> Util.unwrap;
  Core_unix.mkdir_p(out_filename);
  out_filename;
};

let build = directory => {
  let out_dir = get_out_dir(directory);
  print_endline(out_dir);
};

let directory = {
  let doc = "The directory of the project to build";
  Arg.(
    value
    & opt(string, ".")
    & info(["d", "directory"], ~docv="DIRECTORY", ~doc)
  );
};

let build_t = {
  Term.(const(build) $ directory);
};
