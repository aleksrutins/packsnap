{ nixpkgs ? (import ../sources.nix).nixpkgs
, pkgs ? import nixpkgs {} }:
{
  buildPlan = variables: contents: libraries: runCmd:
    with builtins;
    {
      extraCommands = ''
        if [ -d $HOME/.nix-profile/etc/profile.d ]; then
          for i in $HOME/.nix-profile/etc/profile.d/*.sh; do
            if [ -r $i ]; then
              . $i
            fi
          done
        fi
      '';
      copyToRoot = 
        pkgs.buildEnv {
          name = "image-root";
          paths = contents;
          pathsToLink = ["/bin" "/lib"];
        };
      config = {
        Env = 
          let 
          libraryPaths = (pkgs.lib.makeLibraryPath libraries);
          setLibraryPaths = ''LD_LIBRARY_PATH="${libraryPaths}:$LD_LIBRARY_PATH"'';
          in (concatLists [
              [
                setLibraryPaths
              ] 
              variables
            ]);
        Cmd = runCmd;
      };
    };
}