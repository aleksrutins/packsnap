open ProviderBase

module NodeProvider : Provider = struct
  module PackageManager = struct
    type t = Npm | Yarn | Pnpm

    let name = function
    | Npm -> "npm"
    | Yarn -> "yarn"
    | Pnpm -> "pnpm"

    let _get_lockfile_name pm =
      match pm with
      | Npm -> "package-lock.json"
      | Yarn -> "yarn.lock"
      | Pnpm -> "pnpm-lock.yaml"
    
    let detect path =
      let exists f = Sys.file_exists (Filename.concat path f) in
      if exists "yarn.lock" then Yarn
      else if exists "pnpm-lock.yaml" then Pnpm
      else Npm

    let get_install_cmd pm =
      match pm with
      | Npm -> "npm ci"
      | Yarn -> "yarn"
      | Pnpm -> "pnpm install"
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
      String.split_on_char '.' version 
      |> List.hd
      |> String.to_seq
      |> Seq.filter (fun (c) -> '0' < c && c < '9') (* Only the numbers *)
      |> String.of_seq
    with _ -> "18"

  let get_build_cmds path =
    get_install_cmd path
    :: if has_script "build" path then
      [ (String.concat (PackageManager.name (get_package_manager path)) [" run build"]) ]
    else []

  let plan_build path =
    BuildPlan.create_plan
      [
        Snap("node", get_node_version path)
      ]
      (get_build_cmds path)
      ""
end

let%test _ =
  NodeProvider.detect "../examples/node" = true
  && let plan = NodeProvider.plan_build "../examples/node" in
    (List.exists (fun p -> p = (Package.Snap("node", "18"))) plan.packages)