let
  packages = pkgs:
    with pkgs; [
      libpq
      opentofu
      slack
      kubernetes-helm
    ];
  workConfig = {pkgs, ...}: {
    environment.systemPackages = packages pkgs;
  };
in
  _: {
    nixos.work = workConfig;
    darwin.work = workConfig;
  }
