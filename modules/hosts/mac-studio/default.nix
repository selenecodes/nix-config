{inputs, ...}: let
  username = "selene";
in {
  darwin.configurations.studio.module = {pkgsStable, ...}: {
    imports = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager
    ];

    system.primaryUser = username;
    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
    };

    nix-homebrew = {
      enable = true;
      user = username;
      enableRosetta = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit pkgsStable;};
      backupFileExtension = "backup";
      overwriteBackup = true;
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];
      users.${username} = {
        home.stateVersion = "26.05";
      };
    };

    nixpkgs.hostPlatform = "aarch64-darwin";
    networking.knownNetworkServices = [
      "Ethernet"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
  };
}
