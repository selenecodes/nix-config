#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

if rg -q 'config\.(nixos|darwin|homeManager)\.(base|audio|bluetooth|networking|nvidia|gaming|personal|work)' modules; then
  printf 'legacy host or profile selection remains\n' >&2
  exit 1
fi

stack="modules/software/hyprland-caelestia"
for path in "$stack/.interconnected" "$stack/README.md" "$stack/default.nix"; do
  if [[ ! -e "$path" ]]; then
    printf 'missing coupled feature file: %s\n' "$path" >&2
    exit 1
  fi
done

while IFS= read -r module; do
  [[ "$module" == "$stack/default.nix" ]] && continue
  if ! rg -q '\bhyprlandCaelestia\b' "$module"; then
    printf 'Caelestia module bypasses shared targeting: %s\n' "$module" >&2
    exit 1
  fi
done < <(rg --files "$stack" -g '*.nix')
