import Packsnap.Env
import Packsnap.App
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

class BuildPlanGenerator (α : Type u) where
  generatePlan : α → App → Environment → IO BuildPlan