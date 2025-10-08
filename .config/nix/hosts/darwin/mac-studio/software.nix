{ pkgs, lib, ... }: {
  imports = [
    ../shared/software.nix
  ];
  environment.systemPackages = lib.mkAfter (with pkgs; []);

  # `brew list <>` can help pinpoint package name
  # for both ordinary packages and casks
  homebrew.brews = lib.mkAfter [
    "asimov"
    # "opencode"
  ];

  homebrew.taps = lib.mkAfter [
    # "sst/tap"
  ];

  homebrew.casks = lib.mkAfter [
    # "lm-studio"
    # Shared apps
    # "mp3tag"
    # "audiobook-builder"
    # Mac fixes
    "daisydisk"
    # VPN
    "protonvpn"
    # Messaging
    # discord: Install discord manually for now because Krisp doesn't work
    "signal"
    "whatsapp"
    # Gaming
    "moonlight"
    "virtualhereserver"
    "nvidia-geforce-now"
    # "steam"
    # "prismlauncher"
  ];

  # `mas search <>` can help pinpoint package name
  homebrew.masApps = lib.mkAfter{
    "Infuse" = 1136220934;
    # TODO: fix prologue issue
    # "Prologue" = 1459223267;
  };
}
