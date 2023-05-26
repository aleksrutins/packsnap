import Lake
open Lake DSL

package «packsnap» {
  
}

require std4 from git "https://github.com/leanprover/std4"

lean_lib «Packsnap» {
  -- add library configuration options here
}

@[default_target]
lean_exe «packsnap» {
  root := `Main
}
