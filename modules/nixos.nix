{
  config,
  lib,
  evalModulesModule,
  ...
}: let
  cfg = config.nixos;
  mod = lib.mkOption {type = lib.types.deferredModule;};
in {
  options.nixos = {
    base = mod;
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
                  networking.hostName = lib.mkDefault name;
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
