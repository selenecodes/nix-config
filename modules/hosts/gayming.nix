{
  config,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  username = "selene";
  noctaliaPackage = inputs.noctalia.packages.${system}.default;
in {
  nixos.configurations.gayming.module = {pkgs, ...}: {
    imports = [
      config.nixos.base
      config.nixos.audio
      config.nixos.bluetooth
      config.nixos.networking
      config.nixos.nvidia
      config.nixos.desktop
      config.nixos.gaming
      config.nixos.wayland
      config.nixos.personal
      inputs.home-manager.nixosModules.home-manager
    ];

    networking = {
      hostName = "gayming";
      networkmanager.enable = true;
      firewall.enable = true;
    };

    time.timeZone = "Europe/Amsterdam";
    i18n.defaultLocale = "en_GB.UTF-8";

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-substituters = ["https://vicinae.cachix.org"];
      extra-trusted-public-keys = ["vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="];
      auto-optimise-store = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nixpkgs.config.allowUnfree = true;

    # Skipping tests while upstream sorts it out, revert once
    # Hydra consistently builds openldap green.
    # See: https://github.com/NixOS/nixpkgs/issues/513245
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs (_: {
          doCheck = false;
        });
      })
    ];

    users.users.${username} = {
      isNormalUser = true;
      home = "/home/${username}";
      extraGroups = ["wheel" "networkmanager" "input" "docker" "audio" "gamemode" "video" "render" "plugdev"];
      shell = pkgs.zsh;
    };

    environment.systemPackages = [noctaliaPackage];

    security.sudo.wheelNeedsPassword = true;

    programs.zsh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [inputs.catppuccin.homeModules.catppuccin];
      users.${username} = {
        imports = [
          config.homeManager.base
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

    system.stateVersion = "25.11";
  };
}
