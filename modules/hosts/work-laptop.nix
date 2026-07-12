{
  config,
  inputs,
  ...
}: let
  username = "selene.blok";
in {
  darwin.configurations.rwslaptop.module = {lib, ...}: {
    imports = [
      config.darwin.base
      config.darwin.work
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
        ];
        home.stateVersion = "25.11";
        home.file.".zshrc".source = ./darwin/files/.zshrc;
      };
    };

    nixpkgs.hostPlatform = "aarch64-darwin";
    security.pam.services.sudo_local.touchIdAuth = true;
    networking.knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];

    homebrew.casks = lib.mkAfter ["displaylink" "microsoft-teams"];
  };
}
