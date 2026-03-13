flake_dir := "~/nix-config"

# Build darwin configuration
build-darwin device:
  sudo darwin-rebuild switch --flake {{flake_dir}}#{{device}}

# Build nixos configuration
build-nixos device:
  sudo nixos-rebuild switch --flake {{flake_dir}}#{{device}}

# Auto-detect and build current system
build device:
  #!/usr/bin/env bash
  if [[ "$OSTYPE" == "darwin"* ]]; then
    just build-darwin {{device}}
  else
    just build-nixos {{device}}
  fi

# Check flake configuration
check:
  nix flake check --no-build {{flake_dir}}

# Update flake inputs
update:
  nix flake update --flake {{flake_dir}}

# Clean up old generations
clean:
  nix-collect-garbage

# List system generations
versions:
  #!/usr/bin/env bash
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo darwin-rebuild --list-generations
  else
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
  fi

# Rollback to previous generation
rollback:
  #!/usr/bin/env bash
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sudo darwin-rebuild switch --rollback
  else
    sudo nixos-rebuild switch --rollback
  fi

# Show software organization structure
show-software:
  @echo "=== System Packages ==="
  tree {{flake_dir}}/shared/software -L 2
  @echo ""
  @echo "=== Home-Manager Packages ==="
  tree {{flake_dir}}/shared/home/software -L 2

# List common packages
list-common:
  @echo "=== Common System Packages ==="
  @rg "environment\.systemPackages.*with pkgs;" {{flake_dir}}/shared/software/common/default.nix -A 20
  @echo ""
  @echo "=== Common Home Packages ==="
  @ls {{flake_dir}}/shared/home/software/common/*.nix

# List work packages
list-work:
  @echo "=== Work System Packages ==="
  @rg "environment\.systemPackages.*with pkgs;" {{flake_dir}}/shared/software/work/default.nix -A 10 || echo "No work packages"
  @echo ""
  @echo "=== Work Home Packages ==="
  @ls {{flake_dir}}/shared/home/software/work/*.nix 2>/dev/null || echo "No work packages"

# List personal packages
list-personal:
  @echo "=== Personal System Packages ==="
  @rg "environment\.systemPackages.*with pkgs;" {{flake_dir}}/shared/software/personal/default.nix -A 10 || echo "No personal packages"
  @echo ""
  @echo "=== Personal Home Packages ==="
  @ls {{flake_dir}}/shared/home/software/personal/*.nix 2>/dev/null || echo "No personal packages"