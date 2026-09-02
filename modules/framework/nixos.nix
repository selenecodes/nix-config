{
  config,
  lib,
  inputs,
  evalModulesModule,
  featureIndex,
  ...
}: let
  cfg = config.nixos;
  mod = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
  };
in {
  options.nixos = {
    base = mod;
    audio = mod;
    bluetooth = mod;
    networking = mod;
    nvidia = mod;
    desktop = mod;
    gaming = mod;
    wayland = mod;
    personal = mod;
    work = mod;

    configurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          {name, ...}: {
            imports = [
              evalModulesModule
              {
                fn = lib.nixosSystem;
                module = {
                  config,
                  pkgs,
                  ...
                }: {
                  networking.hostName = lib.mkDefault name;
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
                  imports = (featureIndex name).nixos;
                  home-manager.sharedModules = (featureIndex name).homeManager;
                };
              }
            ];
          }
        )
      );
    };
  };

  config.flake.nixosConfigurations =
    lib.mapAttrs (_: {evaluation, ...}: evaluation) cfg.configurations;
}
