{ inputs, config, pkgs, lib, ... }: let
  username = "seleneblok";
in {
  imports = [
    ../shared/configuration.nix
    ./software.nix
  ];
  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/seleneblok";
  };
  nix-homebrew = {
    enable = true;
    user = username;
  };
  home-manager.users.${username} = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  nixpkgs.hostPlatform = "x86_64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}