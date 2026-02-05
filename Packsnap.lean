import Packsnap.Output
import Packsnap.Plan
import Packsnap.Provider
import Packsnap.Providers.Node
import Packsnap.Providers.Go

open Packsnap.Util
open Packsnap.Providers

def checkPlan [BuildPlanGenerator α] (path : System.FilePath) (provider : α) : IO (Option BuildPlan) := do
  let app: App := {
    path
  }
  let env: Environment := { env := [("APP_ENV", "production")] }
  if (← BuildPlanGenerator.detect provider app env) then
    return (some <| ← BuildPlanGenerator.generatePlan provider app env)
  else return none

def planBuild (path : System.FilePath) : IO (Option BuildPlan) := do
  if let some plan ← checkPlan path Node.NodeProvider.mk then
    return (some plan)
  else if let some plan ← checkPlan path Go.GoProvider.mk then
    return (some plan)
  else
    return none


def runBuild (path : String) : IO UInt32 := do
  if let some plan ← planBuild path then
    Packsnap.Util.printPlan plan
    IO.println ""
    if let some buildPath ← plan.createBuildEnv then
      let proc ← IO.Process.spawn {
        cmd := "docker"
        args := #["build", "."]
        cwd := buildPath
        env := (plan.env.env.map (λ (k, v) => (k, some v))).toArray
      }
      return ← proc.wait
    else
      IO.eprintln "failed to create build plan"
      return 1
  else
    IO.eprintln "failed to create build plan"
    return 1

def runInfo (path : String) : IO UInt32 := do
  if let some plan ← planBuild path then
    Packsnap.Util.printPlan plan
    return 0
  else
    IO.eprintln "failed to create build plan"
    return 1
