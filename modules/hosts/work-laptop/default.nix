{inputs, ...}: let
  system = "x86_64-linux";
  username = "selene";
in {
  nixos.configurations.rwslaptop.module = {
    lib,
    pkgs,
    pkgsStable,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    myConfig.user.name = username;

    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 2;
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

    security.sudo.wheelNeedsPassword = true;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit pkgsStable;};
      backupFileExtension = "backup";
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];
      users.${username} = {
        home = {
          stateVersion = "26.05";
          file.".face".source = ../../../assets/avatars/yachiyo.png;
        };
        xdg.configFile."caelestia/hypr-user.lua".text = lib.mkAfter ''
          hl.monitor({
            output = "eDP-1",
            scale = 1.5,
          })
        '';
      };
    };

    nixpkgs = {
      hostPlatform = system;
      config.allowUnfree = true;
    };
    system.stateVersion = "26.05";
  };
}
