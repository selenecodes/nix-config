{ config, inputs, ... }:
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
  security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}
