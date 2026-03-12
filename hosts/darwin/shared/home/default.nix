{ pkgs, lib, ... }:

let
  myFont = "JetBrainsMono Nerd Font";
in

{
  imports = [
    ../../../../shared/home/software/bun.nix
    ../../../../shared/home/software/ghostty.nix
    ../../../../shared/home/software/git.nix
    ../../../../shared/home/software/git-cliff.nix
    (import ../../../../shared/home/software/vscode.nix { inherit pkgs myFont; })
    ../../../../shared/home/software/zoxide.nix
    ./software/aerospace.nix
    # (import ../../../../shared/home/software/codex.nix { inherit pkgs; })
  ];

  home = {
    file."./.config/pip/pip.conf".source = "${../../../../shared/home/files/work/pip.conf}";
    file."./.config/opencode/opencode.json".source = "${../../../../shared/home/files/common/opencode-config.json}";
    file."./.codex/config.toml".source = "${../../../../shared/home/files/work/codex-config.toml}";
    file."./.ssh/config".source = "${../../../../shared/home/files/common/ssh-config}";
    file."./.condarc".source = "${../../../../shared/home/files/common/.condarc}";
    file.".p10k.zsh".source = "${../../../../shared/home/files/common/.p10k.zsh}";
    file.".zshrc".source = "${./files/.zshrc}";
    # file.".config/linearmouse/linearmouse.json".source = "${./files/linearmouse.json}";
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
