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
    osxphotosArchive = lib.mkOption {
      type = lib.types.deferredModule;
      default = {};
    };

    configurations = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule (
          _: {
            imports = [
              evalModulesModule
              {fn = inputs.nix-darwin.lib.darwinSystem;}
            ];
          }
        )
      );
    };
  };

  config.flake.darwinConfigurations =
    lib.mapAttrs (_: {evaluation, ...}: evaluation) cfg.configurations;
}
