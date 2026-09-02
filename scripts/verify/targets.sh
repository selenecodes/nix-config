#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"

VERIFY_ROOT="$root" nix eval --impure --expr '
  let
    root = builtins.getEnv "VERIFY_ROOT";
    flake = builtins.getFlake root;
  in
    import (root + "/scripts/verify/target-validation.nix") {
      lib = flake.inputs.nixpkgs.lib;
    }
' >/dev/null
