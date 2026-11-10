# Nix tests

The suite uses [nix-unit](https://nix-community.github.io/nix-unit/). Tests are
Nix attribute sets with `expr` and `expected`, or `expectedError` for validation
failures. Each test runs independently and reports its own result.

```sh
just test                  # Run all evaluation tests
just verify                # Flake evaluation, formatting, linting, and tests
nix flake check            # Run the sandboxed test derivation for this platform
```

Run one group directly:

```sh
nix run .#nix-unit -- --flake .#tests.unit.displaylink
```

Alternatively, `nix develop` provides the `nix-unit` executable:

```sh
nix-unit --flake .#tests.unit
```

## Test groups

- `ai-model.nix`: model validation, optional fields, and defaults.
- `ai-provider.nix`: provider validation and local/active-model rules.
- `ai-catalog.nix`: provider aliases and client projections.
- `feature-targeting.nix`: target selection and invalid target declarations.
- `configurations.nix`: output-name uniqueness, host evaluation, Docker, and Zsh.
- `displaylink.nix`: the laptop's DisplayLink service and kernel-package pairing.
- `structure.nix`: repository layout and shared Caelestia targeting.

Register new groups in `default.nix`. Name test attributes with a `test` prefix.
Compare derivation paths or strings, not complete derivation attribute sets.

```nix
testEvdiModuleLoaded = {
  expr = builtins.elem "evdi" config.boot.kernelModules;
  expected = true;
};
```

## Flake and commit integration

`modules/framework/testing.nix` exposes `tests.unit`, adds the nix-unit runner
and development shell, and creates `checks.<system>.nix-unit` through the
upstream flake-parts module. Inputs are supplied explicitly to the sandbox;
tests do not fetch dependencies during their execution.

The direct suite runs all tests. The sandboxed suite excludes full host
evaluation, which is covered by the three named `eval-nixos-*` and `eval-darwin-*`
flake checks. Those evaluate in the outer Nix evaluator because the host
configurations import generated theme files. Such import-from-derivation
cannot build in nix-unit's isolated evaluation store on macOS. All three host
evaluation checks also run with `nix flake check --no-build`.

`just check` uses `nix flake check --no-build`, so it evaluates configuration
and check derivations but does not run the tests. The pre-commit hook calls
`just verify`, which also runs `just test` explicitly.

These are evaluation tests. They do not build the host systems, boot VMs, or
validate physical DisplayLink hardware. Runtime integration tests can later
use `pkgs.testers.runNixOSTest` on a Linux builder.
