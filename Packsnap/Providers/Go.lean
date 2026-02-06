import Packsnap.Provider
import Packsnap.Util
import Packsnap.Plan

open Packsnap.Util

namespace Packsnap.Providers.Go

structure GoProvider where

instance : Provider GoProvider where
  name _ := "golang"
  detect _self app _env := app.includesFile "go.mod"
  getBaseImage _self _app _env := pure "golang:alpine"
  getEnvironment _self _app env := pure env
  getBuildPhases _self _app _env := do
    let installPhase := Util.Phase.install [] ["go mod download"] (some ["go.mod", "go.sum"])
    let buildPhase := Util.Phase.build ["go build -ldflags=\"-w -s\" -o out"]

    pure <| installPhase :: [buildPhase]
  getEntrypoint _self _app _env := pure {
    includeFiles := ["out"]
    command := "./out"
  }
