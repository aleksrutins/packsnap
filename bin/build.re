open! Core;
open Cmdliner;
open AppInfo;
open Packsnap;
open Packsnap.Util;
open Option;
open PacksnapProviders;

let get_out_dir = directory => {
  let filename = Filename.basename(Filename_unix.realpath(directory));
  let out_filename =
    Dirs.cache_dir >>| Filename.concat(_, filename) |> unwrap;
  Core_unix.mkdir_p(out_filename);
  out_filename;
};

let build = (directory, tag) => {
  let out_dir = get_out_dir(directory);
  let plan = Plan.plan_build(directory) |> unwrap_context("No providers passed detection.");
  let dockerfile = PacksnapDockerfile.Builder.build_dockerfile(plan);
  let output = Out_channel.create(Filename.concat(out_dir, "Dockerfile"));
  
  Printf.fprintf(output, "%s\n", dockerfile);

  Out_channel.flush(output);
  Out_channel.close(output);

  FileUtil.cp(FileUtil.ls(directory), out_dir, ~recurse=true, ~preserve=false);

  let pid = Spawn.spawn(
    ~env=(
      Spawn.Env.of_list(
        List.concat([
          Core_unix.environment() |> Array.to_list,
          plan.env
          |> EnvHash.to_sequence
          |> Base.Sequence.map(~f=(((k, v)) => k ++ "=" ++ v))
          |> Base.Sequence.to_list
        ])
      )
    ),
    ~cwd=(Spawn.Working_dir.Path(out_dir)),
    ~prog="/bin/sh",
    ~argv=["sh", "-c", "docker build -t \"" ++ tag ++ "\" ."],
    ~stdin=Caml_unix.stdin,
    ~stdout=Caml_unix.stdout,
    ~stderr=Caml_unix.stderr,
    ()
  ) |> Pid.of_int;

  Core_unix.waitpid(pid) |> ignore;

  print_endline("Done! Run your image with `docker run -it " ++ tag ++ "`.");
  ();
};

let directory = {
  let doc = "The directory of the project to build";
  Arg.(
    value
    & opt(string, ".")
    & info(["d", "directory"], ~docv="DIRECTORY", ~doc)
  );
};

let tag = {
  let doc = "The name of the resulting image";
  Arg.(
    value
    & opt(string, "packsnap-image")
    & info(["t", "tag"], ~docv="TAG", ~doc)
  )
}

let build_t = Term.(const(build) $ directory $ tag);
