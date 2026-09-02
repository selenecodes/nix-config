let
  packages = pkgs:
    with pkgs; [
      alejandra
      azure-cli
      bat
      deadnix
      fd
      fnm
      fzf
      gnupg
      just
      ripgrep
      pyright
      ruff
      statix
      tree
      uv
      nixd
    ];
  fonts = pkgs: [pkgs.nerd-fonts.jetbrains-mono];
  systemConfig = {pkgs, ...}: {
    fonts.packages = fonts pkgs;
    environment.systemPackages = packages pkgs;
  };
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["gayming" "rwslaptop"];
          module = systemConfig;
        };
        darwin = {
          targets = ["studio"];
          module = systemConfig;
        };
      }
    ];
  }
