import Packsnap.Plan
import Packsnap.Provider
import Packsnap.Providers.Node

open Packsnap.Util
open Packsnap.Providers

def checkPlan [BuildPlanGenerator α] (path : System.FilePath) (provider : α) : IO (Option BuildPlan) := do
  let app: App := {
    path
  }
  let env: Environment := { env := [] }
  if (← BuildPlanGenerator.detect provider app env) then
    return (some <| ← BuildPlanGenerator.generatePlan provider app env)
  else return none

def planBuild (path : System.FilePath) : IO (Option BuildPlan) := do
  if let some plan ← checkPlan path Node.NodeProvider.mk then
    return (some plan)
  else
    return none
