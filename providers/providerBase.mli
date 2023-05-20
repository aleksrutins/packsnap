module type Provider = sig
  val detect : string -> bool
  val plan_build : string -> BuildPlan.t
end
