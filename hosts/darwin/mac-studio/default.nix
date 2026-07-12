{ config, inputs, ... }:
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

  home-manager = {
    users.${username} = import ./home.nix;
    sharedModules = [
      inputs.catppuccin.homeModules.catppuccin
      ../../../modules/home
    ];
    extraSpecialArgs = {
      inherit inputs;
      isDarwin = true;
      isWork = config.myconfig.isWork;
      isPersonal = config.myconfig.isPersonal;
      isGaming = config.myconfig.isGaming;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    overwriteBackup = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.knownNetworkServices = [
    "Ethernet"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}
