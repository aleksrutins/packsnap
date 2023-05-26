import Lean.Data.Json
open Lean

namespace Packsnap.Util

structure App : Type where
  path : System.FilePath

def App.includesFile (self : App) (name : String) : IO Bool :=
  let filePath := System.FilePath.join self.path name
  filePath.pathExists
  
def App.readFile (self : App) (name : String) : IO String :=
  IO.FS.readFile (System.FilePath.join self.path name)
  
  -- adapted from https://github.com/leanprover/std4/blob/d02dea6b813b41369e538b128360195d83f2d1bc/scripts/runLinter.lean#LL10C6-L10C6

def App.readJson (α) [FromJson α] (self : App) (name : String) : IO α := do
    let path := System.FilePath.join self.path name
    let _ : MonadExceptOf String IO := ⟨throw ∘ IO.userError, fun x _ => x⟩
    liftExcept <| fromJson? <|← liftExcept <| Json.parse <|← IO.FS.readFile path