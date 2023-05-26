import Packsnap.Provider
import Packsnap.App
import Packsnap.Env
import Lean.Data.Json

open Packsnap.Util
open Lean

namespace Packsnap.Providers

structure PackageJson where
  engines : List (String × String)
deriving FromJson

structure NodeProvider where

def defaultNodeVersion := "18"

def getMajorVersion (version : String) : String := 
  if let some major := (version.splitOn ".").head? then
    major
  else
    defaultNodeVersion

def getNodeVersion (app : App) : IO String := do
  try
    let package_json ← app.readJson PackageJson "package.json"
    match package_json.engines.lookup "node" with
    | some version => pure (getMajorVersion version)
    | none => pure defaultNodeVersion
  catch _ => pure defaultNodeVersion
  

instance : Provider NodeProvider where
  detect self app env := app.includesFile "package.json"

  getBaseImage self app env := do
    let version ← getNodeVersion app
    pure s!"node:{version}"
  
  getEnvironment self app env := pure env

  getBuildPhases self app env := pure []
  getEntrypoint self app env := pure {
    includeFiles := ["."]
    command := "true"
  }