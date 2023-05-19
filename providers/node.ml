open ProviderBase

module Node : Provider = struct
  let detect path =
    Sys.file_exists (Filename.concat path "package.json")
end