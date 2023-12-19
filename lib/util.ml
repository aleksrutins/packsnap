open! Core

module EnvHash = Map.Make (String)

exception NoValueException of string

let ( ++ ) left right = String.concat [ left; right ]

module Option = struct
  include Option

  let unwrap_context ctx = function
  | None -> raise (NoValueException ctx)
  | Some x -> x

  let unwrap opt = unwrap_context "unwrap: option is none" opt
end