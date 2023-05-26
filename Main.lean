import «Packsnap»

def main : IO UInt32 := do
  if let some plan ← planBuild "." then
    if let some buildPath ← plan.createBuildEnv then
      let proc ← IO.Process.spawn {
        cmd := "docker"
        args := #["build", "."]
        cwd := buildPath
        env := (plan.env.env.map (λ (k, v) => (k, some v))).toArray
      }
      return ← proc.wait
  pure 1