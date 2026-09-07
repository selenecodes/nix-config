#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

nixos_names="$(nix eval --raw .#nixosConfigurations --apply 'configurations: builtins.concatStringsSep "\n" (builtins.attrNames configurations)')"
darwin_names="$(nix eval --raw .#darwinConfigurations --apply 'configurations: builtins.concatStringsSep "\n" (builtins.attrNames configurations)')"

while IFS= read -r name; do
  [[ -z "$name" ]] && continue
  nix eval ".#nixosConfigurations.$name.config.system.build.toplevel.drvPath" >/dev/null
  if [[ "$(nix eval --json ".#nixosConfigurations.$name.config.virtualisation.docker.enable")" != "true" ]]; then
    printf 'Docker is not enabled for NixOS output: %s\n' "$name" >&2
    exit 1
  fi
done <<<"$nixos_names"

while IFS= read -r name; do
  [[ -z "$name" ]] && continue
  nix eval ".#darwinConfigurations.$name.system.drvPath" >/dev/null
  if [[ "$(nix eval --json ".#darwinConfigurations.$name.config.programs.zsh.enable")" != "true" ]]; then
    printf 'system Zsh is not enabled for Darwin output: %s\n' "$name" >&2
    exit 1
  fi
done <<<"$darwin_names"
