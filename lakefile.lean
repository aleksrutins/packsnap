import Lake
open Lake DSL

package «packsnap» {
  -- add package configuration options here
}

lean_lib «Packsnap» {
  -- add library configuration options here
}

@[default_target]
lean_exe «packsnap» {
  root := `Main
}
