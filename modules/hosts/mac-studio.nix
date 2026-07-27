{
  config,
  inputs,
  ...
}: let
  username = "selene";
in {
  darwin.configurations.studio.module = {lib, ...}: {
    imports = [
      config.darwin.base
      config.darwin.personal
      config.darwin.work
      config.darwin.osxphotosArchive
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
      backupFileExtension = "backup";
      overwriteBackup = true;
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];
      users.${username} = {
        imports = [
          config.homeManager.base
          config.homeManager.work
          config.homeManager.osxphotosArchive
        ];
        home.stateVersion = "26.05";
      };
    };

    nixpkgs.hostPlatform = "aarch64-darwin";
    networking.knownNetworkServices = [
      "Ethernet"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];

    homebrew.brews = lib.mkAfter ["asimov" "gh"];
    homebrew.casks = lib.mkAfter ["signal"];
  };
}
