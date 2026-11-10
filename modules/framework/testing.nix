{
  inputs,
  lib,
  ...
}: let
  systems = ["x86_64-linux" "aarch64-darwin"];
  flattenInput = ancestors: name: input:
    lib.optionals (!(builtins.elem input.outPath ancestors)) (
      [
        {
          inherit name;
          value = input.outPath;
        }
      ]
      ++ lib.concatLists (lib.mapAttrsToList (
        childName: child: flattenInput (ancestors ++ [input.outPath]) "${name}/${childName}" child
      ) (input.inputs or {}))
    );
  testInputs = builtins.listToAttrs (
    lib.concatLists (lib.mapAttrsToList (flattenInput []) (builtins.removeAttrs inputs ["self"]))
  );
in {
  imports = [inputs.nix-unit.modules.flake.default];

  inherit systems;
  flake.tests =
    {
      unit = import ../../tests {
        inherit lib;
        inherit (inputs) self;
      };
    }
    // lib.genAttrs systems (system:
      import ../../tests {
        inherit lib;
        inherit (inputs) self;
        evaluationSystem = system;
      });

  perSystem = {
    pkgs,
    system,
    ...
  }: let
    inherit (inputs) self;
    nativeHosts = lib.filterAttrs (_: host: host.pkgs.stdenv.hostPlatform.system == system);
    evaluationCheck = name: drvPath:
      assert builtins.isString drvPath;
        pkgs.runCommand name {} "touch $out";
  in {
    nix-unit = {
      package = pkgs.nix-unit;
      enableSystemAgnostic = false;
      tests = import ../../tests {
        inherit lib self;
        includeSystemEvaluation = false;
      };
      # Include nested inputs so sandboxed tests never fetch dependencies.
      inputs = testInputs;
    };
    # Evaluate full systems in the outer evaluator, where generated theme
    # files can be realised. Only evaluate native hosts: theme generation can
    # require platform-specific builds even with --no-build.
    checks =
      lib.mapAttrs' (name: host:
        lib.nameValuePair "eval-nixos-${name}" (
          evaluationCheck "eval-nixos-${name}" host.config.system.build.toplevel.drvPath
        ))
      (nativeHosts self.nixosConfigurations)
      // lib.mapAttrs' (name: host:
        lib.nameValuePair "eval-darwin-${name}" (
          evaluationCheck "eval-darwin-${name}" host.system.drvPath
        ))
      (nativeHosts self.darwinConfigurations);
    packages.nix-unit = pkgs.nix-unit;
    devShells.default = pkgs.mkShell {
      packages = [pkgs.nix-unit];
    };
  };
}
