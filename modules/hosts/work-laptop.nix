{
  config,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  username = "selene";
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

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

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
          config.homeManager.caelestia
        ];
        home = {
          stateVersion = "26.05";
          file.".face".source = ../assets/avatars/yachiyo.png;
        };
      };
    };

    nixpkgs = {
      hostPlatform = system;
      config.allowUnfree = true;
    };
    system.stateVersion = "26.05";
  };
}
