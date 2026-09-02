{
  config,
  lib,
  inputs,
  evalModulesModule,
  featureIndex,
  ...
}: let
  cfg = config.darwin;
  mod = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };
in {
  options.darwin = {
    base = mod;
    personal = mod;
    work = mod;

    configurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          {name, ...}: {
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
              {
                module = {
                  imports = (featureIndex name).darwin;
                  home-manager.sharedModules = (featureIndex name).homeManager;
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
