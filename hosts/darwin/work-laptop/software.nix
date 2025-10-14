{ pkgs, lib, ... }: {
  imports = [
    ../shared/software.nix
  ];

  environment.systemPackages = lib.mkAfter (with pkgs; []);

  # `brew list <>` can help pinpoint package name
  # for both ordinary packages and casks
  homebrew.brews = lib.mkAfter [ ];

  homebrew.casks = lib.mkAfter [
    # Shared apps
    "displaylink"
    "citrix-workspace"
  ];

  # `mas search <>` can help pinpoint package name
  homebrew.masApps = lib.mkAfter {};
}