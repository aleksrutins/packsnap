module Node : Provider.Provider = struct
  let detect path =
    Sys.file_exists (Filename.concat path "package.json")
end