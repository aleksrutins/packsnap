namespace Packsnap.Util

structure Environment where
  env : List (String × String)

def Environment.getValue (self : Environment) (name : String) : IO (Option String) :=
    match self.env.lookup name with
    | some value => pure (some value)
    | none => IO.getEnv name

def Environment.merge (a : Environment) (b : Environment) : Environment :=
    {
      env := a.env ++ b.env
    }
