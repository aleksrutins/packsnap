import Packsnap.App
import Packsnap.Env
import Packsnap.Plan

open Packsnap Util

namespace Packsnap.Providers

class Provider (α : Type u) where
  detect : α → App → Environment → IO Bool
  getBaseImage : α → App → Environment → IO String   
  getEnvironment : α → App → Environment → IO Environment
  getBuildPhases : α → App → Environment → IO (List Phase)
  getEntrypoint : α → App → Environment → IO (Option Entrypoint)

instance [Provider α] : BuildPlanGenerator α where
  generatePlan self app env := do
    let resultEnv ← Provider.getEnvironment self app env
    let base ← Provider.getBaseImage self app env 
    let build ← Provider.getBuildPhases self app env
    let entry ← Provider.getEntrypoint self app env
    pure {
      app := app
      env := resultEnv
      baseImage := base
      assets := none
      phases := build
      entrypoint := entry
    }