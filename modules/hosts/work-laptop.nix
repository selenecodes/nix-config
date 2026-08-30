{
  config,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  username = "selene";
  noctaliaPackage = inputs.noctalia.packages.${system}.default;
in {
  nixos.configurations.rwslaptop.module = {
    pkgs,
    lib,
    pkgsStable,
    ...
  }: {
    imports = [
      config.nixos.base
      config.nixos.audio
      config.nixos.bluetooth
      config.nixos.networking
      config.nixos.desktop
      config.nixos.wayland
      config.nixos.work
      inputs.home-manager.nixosModules.home-manager
    ];

    myConfig.user.name = username;

    users.users.${username} = {
      isNormalUser = true;
      home = "/home/${username}";
      extraGroups = ["wheel" "networkmanager" "input" "docker" "audio" "video" "render" "plugdev"];
      shell = pkgs.zsh;
    };

    networking = {
      networkmanager.enable = true;
      nftables.enable = true;
      firewall.enable = true;
    };

    services.tailscale.enable = lib.mkForce false;
    security.sudo.wheelNeedsPassword = true;
    environment.systemPackages = [noctaliaPackage];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit pkgsStable;};
      backupFileExtension = "backup";
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];
      users.${username} = {
        imports = [
          config.homeManager.base
          config.homeManager.work
          config.homeManager.wayland
          config.homeManager.noctalia
          config.homeManager.vicinae
        ];
        home = {
          stateVersion = "26.05";
          file.".face".source = ../assets/avatars/yachiyo.png;
        };
        xdg.configFile."niri/config.kdl".source = ./gayming/niri-default-config.kdl;
      };
    };

    nixpkgs = {
      hostPlatform = system;
      config.allowUnfree = true;
    };
    system.stateVersion = "26.05";
  };
}
