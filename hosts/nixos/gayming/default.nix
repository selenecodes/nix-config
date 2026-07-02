{ pkgs, lib, inputs, ... }:

let
  username = "selene";
in {
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./software.nix
    ./services.nix
    ./wayland.nix
    ./gaming.nix
    ../../../modules/profiles/common
    ../../../modules/profiles/personal
  ];

  # Networking
  networking.hostName = "gayming";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Localization
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_GB.UTF-8";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
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
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    })
  ];

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" "networkmanager" "input" "docker" "audio" "gamemode" "video" "render" "plugdev" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true;

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.sharedModules = [ inputs.catppuccin.homeModules.catppuccin ];
  home-manager.users.${username} = import ./home.nix;

  system.stateVersion = "25.11";
}
