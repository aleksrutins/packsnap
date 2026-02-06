import Packsnap.Env
import Packsnap.App
import AssertCmd

open System
open Lean

namespace Packsnap.Util

inductive Pkg where
  | snap (name : String) (channel : Option String) : Pkg
  | deb (name : String) : Pkg
  | apk (name : String) : Pkg
deriving FromJson

structure PkgInfo where
  manager : String
  name : String

def PkgInfo.of (p : Pkg) : PkgInfo :=
  match p with
  | Pkg.snap name channel => {manager := "snap", name := if let some channel := channel then s!"{name}/{channel}" else name}
  | Pkg.deb name => {manager := "deb", name := name}
  | Pkg.apk name => {manager := "apk", name := name}

def Pkg.getInstallCommand (p : Pkg) :=
  match p with
  | Pkg.snap name channel =>
    match channel with
    | some channel => s!"snap install {name} --channel={channel}"
    | none => s!"snap install {name}"
  | Pkg.deb name => s!"apt-get install {name}"
  | Pkg.apk name => s!"apk add {name}"

structure Phase where
  name : String
  pkgs : List Pkg
  includeFiles : Option (List String)
  commands : List String
deriving FromJson

def Phase.install (pkgs : List Pkg) (commands : List String) (includeFiles : Option (List String)) : Phase :=
  {
    name := "install"
    pkgs := pkgs
    includeFiles
    commands
  }

def Phase.build (commands : List String) : Phase :=
  {
    name := "build"
    pkgs := []
    includeFiles := ["."]
    commands
  }

structure Entrypoint where
  includeFiles : Option (List String)
  command: String
deriving FromJson

structure BuildPlan where
  providerName : String
  app : App
  baseImage : String
  env : Environment
  assets : List (String × String)
  phases : List Phase
  entrypoint : Entrypoint

def getBuildDir (homePath : FilePath) (path : FilePath) :=
  homePath / ".packsnap-build" /
    (match path.components.getLastD "" with
    | "" => (path.components.dropLast.getLastD "")
    | p => p)

#assert (getBuildDir "~" "~/.test/hello").toString == "~/.packsnap-build/hello"
#assert (getBuildDir "~" "~/.test/hello/").toString == "~/.packsnap-build/hello"

def BuildPlan.createBuildEnv (plan : BuildPlan) : IO (Option String) := do
  let homeDir <- IO.getEnv "HOME"
  let homePath := homeDir.map FilePath.mk
  match homePath with
  | none => pure none
  | some homePath =>

    let buildDir := getBuildDir homePath plan.app.path

    if ← buildDir.pathExists then IO.FS.removeDirAll buildDir

    IO.FS.createDirAll buildDir

    let currentDir := plan.app.path

    let _ ← IO.Process.run {cmd := "sh", args := #["-c", s!"cp -r {currentDir}/* {buildDir}"]}

    let assetsDirPath := FilePath.join buildDir "assets"
    IO.FS.createDirAll assetsDirPath
    for (name, contents) in plan.assets do
      let path := FilePath.join assetsDirPath name
      let file <- IO.FS.Handle.mk path IO.FS.Mode.write
      file.putStr contents

    let setEnv := String.join (plan.env.env.map (λ (k, v) => s!"
      ARG {k}={v}
      ENV {k}=$\{{k}}\n
    "))

    let phases ← IO.mkRef []

    for phase in plan.phases do
      let copyFiles ← IO.mkRef ""
      if let some files := phase |> Phase.includeFiles then
        for f in files do
          if ← plan.app.includesFile f then
            copyFiles.modify (String.append s!"COPY {f} .\n")

      let installCmds :=
        String.join (phase.pkgs.map (λ p => s!"RUN {p.getInstallCommand}\n"))

      let runCmds :=
        String.join (phase.commands.map (λ cmd => s!"RUN {cmd}\n"))

      let copyFilesS ← copyFiles.get
      phases.modify λ ps =>
        s!"
        {copyFilesS}
        {installCmds}
        {runCmds}
        " :: ps

    phases.modify List.reverse

    let phasesS ← String.join <$> phases.get

    let runCopyFiles :=
      if let some cmds :=
        plan.entrypoint.includeFiles.map
          (λ files =>
            String.join
              (files.map
                (λ f => s!"COPY --from=build {FilePath.join (FilePath.mk "/app") (FilePath.mk f)} .\n")))
      then cmds
      else ""

    let dockerfile := s!"
      FROM {plan.baseImage} AS build
      {setEnv}

      WORKDIR /app
      COPY assets assets
      {phasesS}

      FROM {plan.baseImage}

      WORKDIR /app
      {runCopyFiles}

      CMD {plan.entrypoint.command}
    "

    let dockerfileHandle <- IO.FS.Handle.mk (FilePath.join buildDir "Dockerfile") IO.FS.Mode.write
    dockerfileHandle.putStr dockerfile

    return (some buildDir.toString)

class BuildPlanGenerator (α : Type u) where
  detect : α → App → Environment → IO Bool
  generatePlan : α → App → Environment → IO BuildPlan
