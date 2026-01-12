# Applications that should be installed on all devices. Please note that
# applications which are configured through home-manager go in the
# ./home/{appname}.nix folder and will be installed from there. DO NOT DUPLICATE
# THESE APPS HERE!
{ pkgs, ... }: {
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # aerospace
    docker
    fnm
    fzf
    git
    git-lfs
    just
    neovim
    terraform
    tree
    zoxide
  ];

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
      "azure-cli"
      "backlog-md"
      "bat"
      "fd"
      "gnupg"
      "helm"
      "lazygit"
      "libpq"
      "mas"
      "minikube"
      "socket_vmnet"
      "pinentry-mac"
      "qemu"
      "terragrunt"
      "ripgrep"
    ];

    taps = [];

    greedyCasks = true;
    casks = [
      "1password-cli"
      "1password"
      "arc"
      "betterdisplay"
      "bettermouse"
      "claude"
      "claude-code"
      "cleanshot"
      "datagrip"
      "ghostty"  # Remove ghostty and enable ./home/ghostty once the pkg is no longer broken
      "git-credential-manager"
      "miniconda"
      "obsidian"
      # "ollama-app"
      "plexamp"
      "raycast"
      "slack"
      "soundsource"
    ];

    # `mas search <>` can help pinpoint package name
    masApps = {
      "1Password for Safari" = 1569813296;
      "Amphetamine" = 937984704;
    };
  };
}
