open ProviderBase
open Node

let providers: (module Provider) array = [|
  (module NodeProvider)
|]

let plan_build path =
  let provider = providers |> Array.find_opt 
    (fun provider ->
      let module ProviderT = (val provider : Provider) in
      ProviderT.detect path) in
  match provider with
  | None -> None
  | Some provider ->
    let module ProviderT = (val provider : Provider) in
    Some (ProviderT.plan_build path)