let
  packages = pkgs:
    with pkgs; [
      libpq
      opentofu
      slack
    ];
in
  _: {
    nixos.work = {pkgs, ...}: {
      environment.systemPackages = packages pkgs;
    };
    darwin.work = {pkgs, ...}: {
      environment.systemPackages = packages pkgs;
    };
  }
