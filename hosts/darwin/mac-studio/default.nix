{ config, inputs, lib, ... }:
let username = "selene"; in
{
  imports = [ ./packages.nix ];

  myconfig.isPersonal = true;
  myconfig.isWork = true;

  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/selene";
  };

  nix-homebrew = {
    enable = true;
    user = username;
    enableRosetta = true;
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
  networking.knownNetworkServices = [
    "Ethernet"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}
