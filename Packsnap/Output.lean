import Colorized
import Packsnap.Plan

open Colorized

namespace Packsnap.Util

def printMeta k v :=
  IO.println <| (Colorized.style Style.Bold k ++ ":") ++ " " ++ v

def printHeader (title : String) (divider : Char) := do
  IO.println ""
  IO.println <| Colorized.style Style.Bold title
  IO.println <| Colorized.style Style.Faint (title.map (λ _ => divider))

def printList (title : String) (divider : Char) (l : List String) := do
  printHeader title divider
  for item in l do
    IO.println <| (Colorized.style Style.Faint "• ") ++ item
  return ()


def printPlan (plan : Util.BuildPlan) : IO Unit := do
  printMeta "provider" plan.providerName
  printMeta "base" plan.baseImage

  let packages :=
    (plan.phases.flatMap (λ p => p.pkgs)
    |> List.map PkgInfo.of
    |> List.map
      (λ pi => (Colorized.style Style.Faint <| pi.manager ++ ":") ++ pi.name))

  if packages.length > 0 then
    printList "packages" '*' packages


  printHeader "phases" '*'
  for phase in plan.phases do
    if phase.commands.length > 0 then
      printList phase.name '─' phase.commands

  printList "start" '*' [plan.entrypoint.command]
  return
