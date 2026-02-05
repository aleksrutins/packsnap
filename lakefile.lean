import Lake
open Lake DSL

package «packsnap» {

}

-- require "leanprover-community" / "batteries" @ git "main"

lean_lib «Packsnap» {
  -- add library configuration options here
}

@[default_target]
lean_exe «packsnap» {
  root := `Main
}
