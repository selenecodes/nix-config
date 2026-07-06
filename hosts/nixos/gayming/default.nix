{ config, inputs, pkgs, lib, ... }:
let username = "selene"; in
{
  myconfig.isPersonal = true;
  myconfig.isGaming = true;

  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  networking.hostName = "gayming";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

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

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    solaar
  ];

  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true;

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.sharedModules = [
    inputs.catppuccin.homeModules.catppuccin
    ../../../modules/home
  ];
  home-manager.extraSpecialArgs = {
    inherit inputs;
    isDarwin = false;
    isWork = config.myconfig.isWork;
    isPersonal = config.myconfig.isPersonal;
    isGaming = config.myconfig.isGaming;
  };
  home-manager.users.${username} = import ./home.nix;

  system.stateVersion = "25.11";
}
