import Packsnap.Env
import Packsnap.App

open System

namespace Packsnap.Util

inductive Pkg where
  | snap (name : String) (channel : Option String) : Pkg
  | deb (name : String) : Pkg

def getInstallCommand (p : Pkg) :=
  match p with
  | Pkg.snap name channel =>
    match channel with
    | some channel => s!"snap install {name} --channel={channel}"
    | none => s!"snap install {name}"
  | Pkg.deb name => s!"apt-get install {name}"

structure Phase where
  name : String
  pkgs : List Pkg
  includeFiles : Option (List String)
  commands : List String

structure Entrypoint where
  includeFiles : Option (List String)
  command: String

structure BuildPlan where
  app : App
  baseImage : String
  env : Environment
  assets : Option (List (String × String))
  phases : List Phase
  entrypoint : Option Entrypoint

def createBuildEnv (plan : BuildPlan) : IO (Option String) := do
  let homeDir ← IO.getEnv "HOME"
  let homePath := homeDir.map FilePath.mk
  match homePath with
  | none => pure none
  | some homePath =>
    let buildDir := FilePath.join homePath (FilePath.mk ".packsnap-build")

    IO.FS.removeDir buildDir

    let dir ← IO.FS.createDirAll buildDir
    let assetsDir := FilePath.join buildDir "assets"
    
    

    let setEnv := String.join (plan.env.env.map (λ (k, v) ↦ s!"
      ARG {k}={v}
      ENV {k}=$\{{k}}\n
    "))
    let dockerfile := s!"
      FROM {plan.baseImage} AS build
      {setEnv}
    "
    pure (some buildDir.toString)

class BuildPlanGenerator (α : Type u) where
  generatePlan : α → App → Environment → IO BuildPlan