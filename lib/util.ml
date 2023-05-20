module EnvHash = Map.Make (String)

let ( ++ ) left right = String.concat "" [ left; right ]
