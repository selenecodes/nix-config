# Platform-agnostic software common to all systems
{ pkgs, ... }: {
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # Core dev tools
    docker
    fnm
    fzf
    git
    git-lfs
    just
    neovim
    tree
    zoxide

    # CLI utilities
    bat
    fd
    gnupg
    lazygit
    ripgrep
    uv

    # Common applications
    _1password-cli
    obsidian
    libreoffice
    plexamp
  ];
}
