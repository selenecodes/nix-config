let
  personalConfig = {pkgs, ...}: {
    environment.systemPackages = [pkgs.claude-code];
  };
in
  _: {
    nixos.personal = personalConfig;
    darwin.personal = personalConfig;
  }
