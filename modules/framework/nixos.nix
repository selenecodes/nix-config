{
  config,
  lib,
  inputs,
  evalModulesModule,
  featureIndex,
  ...
}: let
  cfg = config.nixos;
in {
  options.nixos = {
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
