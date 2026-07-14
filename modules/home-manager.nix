{lib, ...}: let
  mod = lib.mkOption {type = lib.types.deferredModule;};
in {
  options.homeManager = {
    base = mod;
    wayland = mod;
    noctalia = mod;
    vicinae = mod;
    work = mod;
  };
}
