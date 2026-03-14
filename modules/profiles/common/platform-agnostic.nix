{ pkgs, lib, ... }: {
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui
    bat
    docker
    fd
    fnm
    fzf
    git-credential-manager
    gnupg
    just
    lazygit
    micromamba
    neovim
    ripgrep
    tree
    uv
    zoxide
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux only apps
    libreoffice
    plexamp
  ];

  # 1Password CLI (Works on both)
  programs._1password.enable = true;

  # Linux-only 1Password GUI & Polkit integration
  # This section will be completely ignored on macOS
  programs._1password-gui = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    polkitPolicyOwners = [ "selene" ];
  };
}
