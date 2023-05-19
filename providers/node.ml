open ProviderBase
open Packsnap.Logger
open Util

module NodeProvider : Provider = struct
  let logger = new logger "node";

  module PackageManager = struct
    type t = Npm | Yarn | Pnpm

    let name = function
    | Npm -> "npm"
    | Yarn -> "yarn"
    | Pnpm -> "pnpm"

    let _get_lockfile_name = function
    | Npm -> "package-lock.json"
    | Yarn -> "yarn.lock"
    | Pnpm -> "pnpm-lock.yaml"
    
    let detect path =
      let exists f = Sys.file_exists (Filename.concat path f) in
      if exists "yarn.lock" then Yarn
      else if exists "pnpm-lock.yaml" then Pnpm
      else if exists "package-lock.json" then Npm
      else begin
        logger#warn "No lockfile found, assuming this project uses NPM; however, this may break the build. Please run `npm install` to generate a lockfile.";
        Npm
      end

    let get_install_cmd = function
    | Npm -> "npm ci"
    | Yarn -> "yarn"
    | Pnpm -> "pnpm install"

    let get_script_cmd script pm = 
      (match pm with
      | Npm -> "run"
      | Yarn -> ""
      | Pnpm -> "")
      |> fun x -> [(name pm); x; script] 
      |> String.concat " "
  end

  let package_json_path path = Filename.concat path "package.json"
  
  let read_package_json path = Yojson.Basic.from_file @@ package_json_path path

  let has_script name path =
    let package_json = read_package_json path in
    let open Yojson.Basic.Util in
    try 
      let _ = package_json |> member "scripts" |> member name in true
    with _ -> false
  
  let get_package_manager path = PackageManager.detect path
  let get_install_cmd path = PackageManager.get_install_cmd (get_package_manager path)

  let detect path =
    Sys.file_exists (package_json_path path)

  let get_node_version path =
    let package_json = Yojson.Basic.from_file (package_json_path path) in
    let open Yojson.Basic.Util in
    try let version = package_json |> member "engines" |> member "node" |> to_string in
      (* only use the major version for the snap channel *)
      String.split_on_char '.' version 
      |> List.hd
      |> String.to_seq
      |> Seq.filter (fun (c) -> '0' < c && c < '9') (* Only the numbers *)
      |> String.of_seq
    with _ -> "18"

  let get_build_cmds path =
    get_install_cmd path
    :: if has_script "build" path then
      [ PackageManager.get_script_cmd "build" (get_package_manager path) ]
    else []

  let get_start_cmd path =
    if has_script "start" path then
      PackageManager.get_script_cmd "start" (get_package_manager path)
    else 
      let package_json = read_package_json path in
      let open Yojson.Basic.Util in
      if package_json |> keys |> List.exists ((=) "main") then
        "node" ++ (package_json |> member "main" |> to_string)
      else
        "node index.js"

  let plan_build path =
    BuildPlan.create_plan
      [
        Snap("node", get_node_version path)
      ]
      (get_build_cmds path)
      (get_start_cmd path)
end

let%test_module "node tests" = (module struct
  let%test "it detects correctly" = NodeProvider.detect "../examples/node" = true

  let%test "it correctly recognizes node" =
    let plan = NodeProvider.plan_build "../examples/node" in
    List.exists ((=) (Package.Snap("node", "18"))) plan.packages

  let%test "it correctly recognizes yarn" =
    let plan = NodeProvider.plan_build "../examples/node-yarn" in
    List.exists ((=) "yarn") plan.build_commands
  
  let%test "it correctly recognizes a build script" =
    let plan = NodeProvider.plan_build "../examples/node-build-script" in
    List.exists ((=) "npm run build") plan.build_commands

  let%test "it correctly recognizes a start script" =
    let plan = NodeProvider.plan_build "../examples/node-start-script" in
    plan.run_command = "npm run start"
end)