import Packsnap.Provider
import Packsnap.App
import Packsnap.Env
import Packsnap.Util
import Lean.Data.Json

open Packsnap.Util
open Lean

namespace Packsnap.Providers.Node

structure PackageJsonEngines where
  node : Option String
deriving FromJson

structure PackageJsonScripts where
  build : Option String
  start : Option String
deriving FromJson

structure PackageJson where
  engines : Option PackageJsonEngines
  scripts : Option PackageJsonScripts
  packageManager : Option String
deriving FromJson

inductive PackageManager where
  | npm
  | yarn
  | pnpm

def PackageManager.fromName (name : Option String) : PackageManager :=
  match name with
  | some "npm" => npm
  | some "yarn" => yarn
  | some "pnpm" => pnpm
  | _ => npm

def PackageManager.getName (self : PackageManager) : String :=
  match self with
  | npm => "npm"
  | yarn => "yarn"
  | pnpm => "pnpm"

def PackageManager.lockFile (self : PackageManager) : String :=
  match self with
  | npm => "package-lock.json"
  | yarn => "yarn.lock"
  | pnpm => "pnpm-lock.yaml"

def PackageManager.getScriptCommand (self : PackageManager) (script : String) : String :=
  s!"{self.getName} run {script}"

def PackageManager.getInstallCommand (self : PackageManager) : String :=
  s!"{self.getName} install"

structure NodeProvider where

def defaultNodeVersion := "24"

def getPackageJson (app : App) : IO PackageJson := app.readJson PackageJson "package.json"

def getPackageManager (app : App) : IO PackageManager := do
  if ← app.includesFile "package-lock.json" then return PackageManager.npm
  if ← app.includesFile "yarn.lock" then return PackageManager.yarn
  if ← app.includesFile "pnpm-lock.yaml" then return PackageManager.pnpm

  let packageJson ← getPackageJson app
  let packageManagerName := packageJson.packageManager.map (λ p => (p.takeWhile Char.isAlpha).toString)
  pure <| PackageManager.fromName packageManagerName

def getNodeVersion (app : App) : IO String := do
  try
    let packageJson ← getPackageJson app
    match packageJson.engines >>= PackageJsonEngines.node with
    | some version => pure <| getMajorVersion version defaultNodeVersion
    | none => pure defaultNodeVersion
  catch _ => pure defaultNodeVersion

def hasScript (app : App) (script : PackageJsonScripts → Option String) : IO Bool := do
  try
    let packageJson ← getPackageJson app
    pure ((packageJson.scripts >>= script).isSome)
  catch _ => pure false


instance : Provider NodeProvider where
  detect _self app _env := app.includesFile "package.json"

  getBaseImage _self app _env := do
    let version ← getNodeVersion app
    pure s!"node:{version}"

  getEnvironment _self _app env := pure env

  getBuildPhases _self app _env := do
    let pm ← getPackageManager app

    let installPhase := Phase.install
      (pm.getInstallCommand :: (if let PackageManager.npm := pm then [] else ["corepack enable"])).reverse
      ["package.json", pm.lockFile]
    let buildPhases :=
      if (← hasScript app PackageJsonScripts.build) then
        [Phase.build [pm.getScriptCommand "build"]]
      else [Phase.build []]

    pure <| installPhase :: buildPhases


  getEntrypoint _self app _env := do
    let pm ← getPackageManager app
    let hasIndex ← app.includesFile "index.js"

    let cmd := if (← hasScript app PackageJsonScripts.start)
      then pm.getScriptCommand "start"
      else
        if hasIndex
        then "node index.js"
        else ""

    return {
      includeFiles := ["."]
      command := cmd
    }
