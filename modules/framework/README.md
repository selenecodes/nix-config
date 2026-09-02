# Configuration framework

The framework turns `nixos.configurations` and `darwin.configurations` into flake outputs. It also projects the feature records from `repository.features` into each output.

`modules.nix` defines feature records and validates their targets. `nixos.nix` and `darwin.nix` build the system configurations. `eval-modules.nix` adapts deferred modules to the NixOS and nix-darwin evaluators.

## Repository invariants

Every system configuration must import the matching Home Manager module. The framework always assigns `home-manager.sharedModules`, even when no Home Manager feature targets the output.

NixOS and Darwin output names must be globally unique. A Home Manager facet targets an output by name without recording its platform. Reusing an output name on both platforms would apply that Home Manager facet to both systems.

Feature facets must use nonempty target lists. A facet can use `"*"` or explicit output names, but it cannot combine both forms. The framework rejects duplicate and unknown targets.

See [Feature targeting style](../../docs/refactors/feature-targeting.md) when adding or moving a feature.
