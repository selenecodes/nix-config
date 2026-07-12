_: {
  nixos.base = {pkgs, ...}: {
    fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];

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
    ];
  };
  darwin.base = {pkgs, ...}: {
    fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];

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
    ];
  };
}
