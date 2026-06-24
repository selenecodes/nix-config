{ pkgs, lib, ... }: {
  imports = [
    ../shared/software.nix
  ];

  # Mac-studio (personal) specific packages
  environment.systemPackages = lib.mkAfter (with pkgs; []);

  homebrew.brews = lib.mkAfter [
    "asimov"
    "gh"
    # "opencode"
  ];

  homebrew.taps = lib.mkAfter [
    # "sst/tap"
  ];

  homebrew.casks = lib.mkAfter [
    # "lm-studio"
    # "mp3tag"
    # "audiobook-builder"
    # "daisydisk"
    # "protonvpn"
    # discord: Install discord manually for now because Krisp doesn't work
    "signal"
    # Gaming
    # "moonlight"
    # "virtualhereserver"
    "logitech-g-hub"
    # "steam"
    # "prismlauncher"
  ];

  homebrew.masApps = lib.mkAfter {
    # "1Password for Safari" = 1569813296;
    "Infuse" = 1136220934;
    "Tailscale" = 1475387142;
    # TODO: fix prologue issue
    # "Prologue" = 1459223267;
  };
}
