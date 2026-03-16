{ inputs, config, pkgs, lib, ... }: let
  username = "selene.blok";
in {
  imports = [
    ../shared/configuration.nix
    ./software.nix
    ../../../modules/profiles/common
    ../../../modules/profiles/work
  ];
  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/selene.blok";
  };
  nix-homebrew = {
    enable = true;
    user = username;
  };
  home-manager.users.${username} = import ./home.nix;
  home-manager.sharedModules = [ inputs.catppuccin.homeModules.catppuccin ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}
