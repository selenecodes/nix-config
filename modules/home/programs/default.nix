{ ... }: {
  imports = [
    ./bun.nix
    ./catppuccin.nix
    ./ghostty.nix
    ./git.nix
    ./obsidian.nix
    ./ssh.nix
    ./vscode.nix
    ./zoxide.nix
    # Conditionally active programs (guard themselves internally)
    ./codex.nix
    ./noctalia.nix
    ./vicinae.nix
  ];
}
