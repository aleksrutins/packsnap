module type Provider = sig
  val detect : string -> bool
end