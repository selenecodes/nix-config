{ pkgs, lib, ... }: {
  imports = [
    ../shared/software.nix
  ];

  # Work-laptop specific packages
  environment.systemPackages = lib.mkAfter (with pkgs; []);

  homebrew.brews = lib.mkAfter [ ];

  homebrew.casks = lib.mkAfter [
    "displaylink"
    "microsoft-teams"
  ];
}