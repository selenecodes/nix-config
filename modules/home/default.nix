{ ... }: {
  imports = [
    ./programs
    ./dotfiles.nix
    ./editorconfig.nix
    ./wayland.nix
  ];
}
