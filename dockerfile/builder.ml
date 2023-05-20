open Packsnap.Util
open Packsnap_providers

let base_image = "ubuntu:mantic"

let package_commands (packages: Package.t list) =
  let open Package in
  packages
  |> List.map (function
  | Snap(name, channel) -> [("snap install " ++ name ++ " --channel=" ++ channel)]
  | Deb info -> [
    (match info.repo with
    | Some repo -> ("add-apt-repository " ++ repo)
    | None -> "true");

    ("apt-get install " ++ info.name)
  ]
  )
  |> List.flatten

let build_dockerfile (plan: BuildPlan.t) =
  let install_cmds = package_commands plan.packages |> List.map ((++) "RUN ") in
  String.concat "\n" [
    Printf.sprintf "FROM %s" base_image;
    String.concat "\n" install_cmds;
    String.concat "\n" plan.build_commands;
    "ENTRYPOINT " ++ plan.run_command;
  ]