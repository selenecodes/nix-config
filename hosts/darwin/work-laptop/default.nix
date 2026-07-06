{ config, inputs, lib, ... }:
let username = "selene.blok"; in
{
  imports = [ ./packages.nix ];

  myconfig.isWork = true;

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
  home-manager.sharedModules = [
    inputs.catppuccin.homeModules.catppuccin
    ../../../modules/home
  ];
  home-manager.extraSpecialArgs = {
    inherit inputs;
    isDarwin = true;
    isWork = config.myconfig.isWork;
    isPersonal = config.myconfig.isPersonal;
    isGaming = config.myconfig.isGaming;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.overwriteBackup = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}
