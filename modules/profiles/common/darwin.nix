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
      "arc"
      "libreoffice-still"
      "plexamp"
    ];

    # `mas search <>` can help pinpoint package name
    masApps = {};
  };
}
