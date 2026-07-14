let
  packages = pkgs:
    with pkgs; [
      bat
      docker
      fd
      fnm
      fzf
      gnupg
      just
      micromamba
      neovim
      ripgrep
      tree
      uv
      lmstudio
    ];
  fonts = pkgs: [pkgs.nerd-fonts.jetbrains-mono];
  systemConfig = {pkgs, ...}: {
    fonts.packages = fonts pkgs;
    environment.systemPackages = packages pkgs;
  };
in
  _: {
    nixos.base = systemConfig;
    darwin.base = systemConfig;
  }
