# Common home-manager software modules
{ pkgs, ... }:
let myFont = "JetBrainsMono Nerd Font"; in {
  imports = [
    ./bun.nix
    ./catppuccin.nix
    ./ghostty.nix
    ./git.nix
    ./git-cliff.nix
    ./obsidian.nix
    ./ssh.nix
    (import ./vscode.nix { inherit pkgs myFont; })
    ./zoxide.nix
  ];
}
