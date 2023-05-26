namespace Packsnap.Util

structure Environment where
  env : List (String × String)

  getValue (name : String) : IO (Option String) :=
    match env.lookup name with
    | some value => pure (some value)
    | none => IO.getEnv name

def Environment.merge (a : Environment) (b : Environment) : Environment :=
    {
      env := a.env ++ b.env
    }