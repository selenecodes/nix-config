{ ... }: let
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
    enableRosetta = true;
  };
  home-manager.users.${username} = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.knownNetworkServices = [
    "Ethernet"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}