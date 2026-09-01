{lib, ...}: let
  mod = lib.mkOption {type = lib.types.deferredModule;};
in {
  options.homeManager = {
    base = mod;
    wayland = mod;
    caelestia = mod;
    work = mod;
  };
}
