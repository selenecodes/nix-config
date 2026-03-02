{ pkgs, lib, ... }: {
  imports = [
    ../shared/software.nix
  ];
  environment.systemPackages = lib.mkAfter (with pkgs; []);

  # `brew list <>` can help pinpoint package name
  # for both ordinary packages and casks
  homebrew.brews = lib.mkAfter [
    "asimov"
    "gh"
    # "opencode"
  ];

  homebrew.taps = lib.mkAfter [
    # "sst/tap"
    "netbirdio/tap"
  ];

  homebrew.casks = lib.mkAfter [
    "claude-code"
    # "lm-studio"
    # Shared apps
    # "mp3tag"
    "netbirdio/tap/netbird-ui"
    # "audiobook-builder"
    # Mac fixes
    # "daisydisk"
    # VPN
    # "protonvpn"
    # Messaging
    # discord: Install discord manually for now because Krisp doesn't work
    "signal"
    # Gaming
    "moonlight"
    "virtualhereserver"
    # "steam"
    # "prismlauncher"
  ];

  # `mas search <>` can help pinpoint package name
  homebrew.masApps = lib.mkAfter{
    "Infuse" = 1136220934;
    "Tailscale" = 1475387142;
    # TODO: fix prologue issue
    # "Prologue" = 1459223267;
  };
}
