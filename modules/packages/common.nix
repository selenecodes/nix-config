let
  packages = pkgs:
    with pkgs; [
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
    ];
  fonts = pkgs: [pkgs.nerd-fonts.jetbrains-mono];
in
  _: {
    nixos.base = {pkgs, ...}: {
      fonts.packages = fonts pkgs;
      environment.systemPackages = packages pkgs;
    };
    darwin.base = {pkgs, ...}: {
      fonts.packages = fonts pkgs;
      environment.systemPackages = packages pkgs;
    };
  }
