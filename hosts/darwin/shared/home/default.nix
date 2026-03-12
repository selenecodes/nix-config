{ pkgs, lib, ... }: 

let
  myFont = "JetBrainsMono Nerd Font";
in

{
  imports = [
    ./software/bun.nix
    ./software/ghostty.nix
    ./software/git.nix
    ./software/git-cliff.nix
    (import ./software/vscode.nix { inherit pkgs myFont; })
    ./software/zoxide.nix
    ./software/aerospace.nix
    # ./software/codex.nix
  ];

  home = {
    file."./.config/pip/pip.conf".source = "${./files/pip.conf}";
    file."./.config/opencode/opencode.json".source = "${./files/opencode-config.json}";
    file."./.codex/config.toml".source = "${./files/codex-config.toml}";
    file."./.ssh/config".source = "${./files/ssh-config}";
    # file.".config/linearmouse/linearmouse.json".source = "${./files/linearmouse.json}";
    file.".condarc".source = "${./files/.condarc}";
    file.".p10k.zsh".source = "${./files/.p10k.zsh}";
    file.".zshrc".source = "${./files/.zshrc}";
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 78;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };
}
