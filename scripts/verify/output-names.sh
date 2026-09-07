#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

nixos_names="$(nix eval --raw .#nixosConfigurations --apply 'configurations: builtins.concatStringsSep "\n" (builtins.attrNames configurations)')"
darwin_names="$(nix eval --raw .#darwinConfigurations --apply 'configurations: builtins.concatStringsSep "\n" (builtins.attrNames configurations)')"

if [[ -z "$nixos_names" || -z "$darwin_names" ]]; then
  printf 'expected at least one NixOS and one Darwin output\n' >&2
  exit 1
fi

duplicates="$(comm -12 <(printf '%s' "$nixos_names" | sort) <(printf '%s' "$darwin_names" | sort))"
if [[ -n "$duplicates" ]]; then
  printf 'output names must be unique across NixOS and Darwin:\n%s\n' "$duplicates" >&2
  exit 1
fi
