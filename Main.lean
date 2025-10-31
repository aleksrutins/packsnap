import «Packsnap»

def main (args: List String) : IO UInt32 := do
  if let some plan ← planBuild
    (match args.get? 0 with
    | some path => path
    | none => ".") then
    if let some buildPath ← plan.createBuildEnv then
      let proc ← IO.Process.spawn {
        cmd := "docker"
        args := #["build", "."]
        cwd := buildPath
        env := (plan.env.env.map (λ (k, v) => (k, some v))).toArray
      }
      return ← proc.wait
    else
      println! "failed to create build plan"
  pure 1
