import Packsnap.App
import Packsnap.Env
import Packsnap.Plan

open Packsnap Util

namespace Packsnap.Providers

class Provider (α : Type u) where
  name : α → String
  detect : α → App → Environment → IO Bool
  getBaseImage : α → App → Environment → IO String
  getEnvironment : α → App → Environment → IO Environment
  getBuildPhases : α → App → Environment → IO (List Phase)
  getEntrypoint : α → App → Environment → IO Entrypoint

instance [Provider α] : BuildPlanGenerator α where
  detect self app env := Provider.detect self app env
  generatePlan self app env := do
    let resultEnv ← Provider.getEnvironment self app env
    let base ← Provider.getBaseImage self app env
    let build ← Provider.getBuildPhases self app env
    let entry ← Provider.getEntrypoint self app env
    pure {
      providerName := Provider.name self
      app := app
      env := resultEnv
      baseImage := base
      assets := []
      phases := build
      entrypoint := entry
    }
