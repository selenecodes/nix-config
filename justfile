flake_dir := justfile_directory()
set positional-arguments

# Build darwin configuration
build-darwin device:
  #!/usr/bin/env bash
  set -euo pipefail
  [[ "$1" =~ ^[A-Za-z0-9_-]+$ ]] || { echo "invalid device name" >&2; exit 2; }
  sudo darwin-rebuild switch --flake "{{flake_dir}}#$1"

# Build nixos configuration
build-nixos device:
  #!/usr/bin/env bash
  set -euo pipefail
  [[ "$1" =~ ^[A-Za-z0-9_-]+$ ]] || { echo "invalid device name" >&2; exit 2; }
  sudo nixos-rebuild switch --flake "{{flake_dir}}#$1"

# Auto-detect and build current system
build device:
  #!/usr/bin/env bash
  set -euo pipefail
  if [[ "$OSTYPE" == "darwin"* ]]; then
    just build-darwin "$1"
  else
    just build-nixos "$1"
  fi

# Check flake configuration
check:
  nix flake check --no-build {{flake_dir}}

# Format all Nix files and fix issues
format:
  alejandra {{flake_dir}}

# Check all Nix files for formatting issues
format-check:
  alejandra --check {{flake_dir}}

# Lint Nix files (structural + dead code)
lint:
  statix check {{flake_dir}}
  deadnix {{flake_dir}}

# Run linting and formatting
verify: check format-check lint
  bash {{flake_dir}}/scripts/verify.sh

# Install the Git hooks
install-hooks:
  git -C {{flake_dir}} config core.hooksPath .githooks

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
