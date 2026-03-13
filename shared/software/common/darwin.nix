# Darwin-specific common software (Homebrew packages)
{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # zap is a more thorough uninstall, ref: https://docs.brew.sh/Cask-Cookbook#stanza-zap
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };

    # `brew list <>` can help pinpoint package name
    # for both ordinary packages and casks
    brews = [
      "gnupg"
      "mas"
      "pinentry-mac"
    ];

    taps = [];

    greedyCasks = true;
    casks = [
      "1password-cli"
      "1password"
      "arc"
      "ghostty"  # Remove ghostty and enable home/ghostty once the pkg is no longer broken
      "git-credential-manager"
      "libreoffice-still"
      "obsidian"
      "plexamp"
      "visual-studio-code"
    ];

    # `mas search <>` can help pinpoint package name
    masApps = {};
  };
}
