let
  packages = pkgs:
    with pkgs; [
      libpq
      opentofu
      slack
      kubernetes-helm
      azure-cli
    ];
  workConfig = {pkgs, ...}: {
    environment.systemPackages = packages pkgs;
  };
in
  _: {
    nixos.work = workConfig;
    darwin.work = workConfig;
  }
