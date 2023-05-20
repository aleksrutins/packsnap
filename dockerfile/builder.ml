open Packsnap.Util
open Packsnap_providers

let package_commands (packages : Package.t list) =
  let open Package in
  packages
  |> List.map (function
       | Snap (name, channel) ->
           [ "snap install " ++ name ++ " --channel=" ++ channel ]
       | Deb info ->
           [
             (match info.repo with
             | Some repo -> "add-apt-repository " ++ repo
             | None -> "true");
             "apt-get -y install " ++ info.name;
           ])
  |> List.flatten

let build_dockerfile (plan : BuildPlan.t) =
  let install_cmds =
    package_commands plan.packages |> List.map (( ++ ) "RUN ")
  in
  String.concat "\n"
    [
      Printf.sprintf "FROM %s AS build" plan.base_image;
      String.concat "\n" install_cmds;
      String.concat "\n" (List.map (( ++ ) "RUN ") plan.build_commands);
      Printf.sprintf "FROM %s" plan.base_image;
      String.concat "\n" (List.map (fun f -> Printf.sprintf "COPY --from=build %s ." f) plan.include_files);
      "ENTRYPOINT " ++ plan.run_command;
    ]

let%test_module "Dockerfile generation" =
  (module struct
    let%expect_test "it can generate a basic dockerfile" =
      let plan = Packsnap_providers.All.plan_build "../examples/node" in
      print_endline @@ build_dockerfile (Option.get plan);
      [%expect
        {|
      FROM node:18 AS build

      RUN npm ci
      FROM node:18
      COPY --from=build . .
      ENTRYPOINT node index.js
    |}]
  end)
