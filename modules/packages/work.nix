let
  packages = pkgs:
    with pkgs; [
      libpq
      opentofu
      slack
    ];
  workConfig = {pkgs, ...}: {
    environment.systemPackages = packages pkgs;
  };
in
  _: {
    nixos.work = workConfig;
    darwin.work = workConfig;
  }
