{
  config,
  lib,
  inputs,
  evalModulesModule,
  ...
}: let
  cfg = config.darwin;
  mod = lib.mkOption {type = lib.types.deferredModule;};
in {
  options.darwin = {
    base = mod;
    personal = mod;
    work = mod;

    configurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          _: {
            imports = [
              evalModulesModule
              {
                fn = inputs.nix-darwin.lib.darwinSystem;
                module = {
                  config,
                  pkgs,
                  ...
                }: {
                  _module.args = {
                    pkgsStable = import inputs.nixpkgs-stable {
                      system = pkgs.stdenv.hostPlatform.system;
                      inherit (config.nixpkgs) config overlays;
                    };
                  };
                };
              }
            ];
          }
        )
      );
    };
  };

  config.flake.darwinConfigurations =
    lib.mapAttrs (_: {evaluation, ...}: evaluation) cfg.configurations;
}
