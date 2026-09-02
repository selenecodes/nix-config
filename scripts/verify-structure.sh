#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

required=(
  assets/avatars/yachiyo.png
  lib/ai/topology.nix
  lib/ai/models/azure.nix
  lib/ai/models/qwen3-8-27b.nix
  modules/framework/darwin.nix
  modules/framework/eval-modules.nix
  modules/framework/modules.nix
  modules/framework/nixos.nix
  modules/config/base/darwin.nix
  modules/config/base/nixos.nix
  modules/config/dotfiles/work/pip.conf
  modules/config/system/macos-defaults.nix
  modules/hosts/gayming/default.nix
  modules/hosts/work-laptop/default.nix
  modules/hosts/mac-studio/default.nix
  modules/software/hyprland-caelestia/.interconnected
)

for path in "${required[@]}"; do
  [[ -e "$path" ]] || {
    printf 'missing required path: %s\n' "$path" >&2
    exit 1
  }
done

if rg -q 'config\.(nixos|darwin|homeManager)\.(base|audio|bluetooth|networking|nvidia|gaming|personal|work)' modules; then
  printf 'legacy host or profile selection remains\n' >&2
  exit 1
fi

nix eval .#nixosConfigurations.gayming.config.system.build.toplevel.drvPath >/dev/null
nix eval .#nixosConfigurations.rwslaptop.config.system.build.toplevel.drvPath >/dev/null
nix eval .#darwinConfigurations.studio.system.drvPath >/dev/null
