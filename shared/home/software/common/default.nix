# Common home-manager software modules
{ pkgs, myFont ? "JetBrainsMono Nerd Font" }: {
  imports = [
    ./bun.nix
    ./ghostty.nix
    ./git.nix
    ./git-cliff.nix
    (import ./vscode.nix { inherit pkgs myFont; })
    ./zoxide.nix
  ];
}
