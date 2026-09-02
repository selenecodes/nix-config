{
  config,
  lib,
  inputs,
  evalModulesModule,
  ...
}: let
  cfg = config.nixos;
  mod = lib.mkOption {type = lib.types.deferredModule;};
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
            ];
          }
        )
      );
    };
  };

  config.flake.nixosConfigurations =
    lib.mapAttrs (_: {evaluation, ...}: evaluation) cfg.configurations;
}
