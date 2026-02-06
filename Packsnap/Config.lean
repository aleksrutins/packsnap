import Packsnap.App
import Packsnap.Plan
import Lean.Data.Json

open Packsnap.Util
open Lean

namespace Packsnap.Config

structure ConfigPhase where
  name : String
  pkgs : Option (List String)
  includeFiles : Option (List String)
  commands : List String
deriving FromJson

def ConfigPhase.toPlan (self : ConfigPhase) : Phase :=
  {
    name := self.name
    pkgs := self.pkgs.getD [] |> List.map
      (λ p =>
        let parts := p.split ":" |> Std.Iter.toList |> List.map String.Slice.toString
        match parts[0]? with
        | some "apk" => Pkg.apk parts[1]!
        | some "deb" => Pkg.deb parts[1]!
        | some "snap" =>
          let nameParts := parts[1]!.split "/" |> Std.Iter.toList |> List.map String.Slice.toString
          Pkg.snap nameParts[0]! nameParts[1]?
        | _ => Pkg.deb p)
    commands := self.commands
    includeFiles := self.includeFiles
  }

structure Config where
  provider : Option String
  baseImage : Option String
  env : Option <| List (String × String)
  phases : Option <| List ConfigPhase
  entrypoint : Option Entrypoint
deriving FromJson

def Config.default : Config := {
  provider := none
  env := none
  phases := none
  entrypoint := none
  baseImage := none
}

def Config.load (app : App) := do
  if ← app.includesFile "packsnap.json" then
    app.readJson Config "packsnap.json"
  else
    return Config.default

def Config.extend (self : Config) (plan : BuildPlan) : BuildPlan := {
  env := if let some env := self.env
    then plan.env.merge ⟨env⟩
    else plan.env
  providerName := plan.providerName
  app := plan.app
  baseImage := self.baseImage.getD plan.baseImage
  assets := plan.assets
  phases := if let some phases := self.phases
    then phases.map (λ p => p.toPlan)
    else plan.phases
  entrypoint := self.entrypoint.getD plan.entrypoint
}
