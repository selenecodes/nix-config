{ inputs, ... }: let
  username = "selene";
in {
  imports = [
    ../shared/configuration.nix
    ./software.nix
    ../../../modules/profiles/common
    ../../../modules/profiles/personal
    ../../../modules/profiles/work
  ];
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
  home-manager.sharedModules = [ inputs.catppuccin.homeModules.catppuccin ];
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
