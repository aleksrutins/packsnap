module EnvHash = Map.Make (String)

exception NoValueException of string

let ( ++ ) left right = String.concat "" [ left; right ]

let unwrap = function
  | None -> raise (NoValueException "Unwrap: option has not value")
  | Some x -> x
