type t =
  | Deb of { repo : string option; name : string }
  | Snap of (string * string)
