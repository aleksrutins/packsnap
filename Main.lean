import «Packsnap»

def printHelp : IO UInt32 := do
  IO.eprintln "usage : packsnap (build) [path]"
  return 1

def runBuild (path : Option String) : IO UInt32 := do
  if let some plan ← planBuild (path.getD ".") then
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

def main (args: List String) : IO UInt32 :=
  if noArgs : args.length < 1 then
    printHelp
  else match args[0] with
    | "build" => runBuild args[1]?
    | _ => printHelp
