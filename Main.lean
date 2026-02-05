import Packsnap
import Packsnap.Output

open Packsnap

def printHelp : IO UInt32 := do
  IO.eprintln "usage : packsnap (build|plan) [path]"
  return 1

def main (args: List String) : IO UInt32 :=
  if noArgs : args.length < 1 then
    printHelp
  else match args[0] with
    | "build" => runBuild <| args[1]?.getD "."
    | "plan" => runInfo <| args[1]?.getD "."
    | _ => printHelp
