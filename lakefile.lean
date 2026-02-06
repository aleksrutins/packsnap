import Lake
open Lake DSL

package «packsnap» {

}

-- require "leanprover-community" / "batteries" @ git "main"
require "algebraic-dev" / "Colorized" @ git "main"
require "pnwamk" / "assertCmd" from git "https://github.com/pnwamk/lean4-assert-command" @ "main"

lean_lib «Packsnap» {
  -- add library configuration options here
}

@[default_target]
lean_exe «packsnap» {
  root := `Main
}
