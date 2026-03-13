{ pkgs, lib, ... }:

let
  myFont = "JetBrainsMono Nerd Font";
in

{
  imports = [
    (import ../../../../shared/home/software/common/default.nix { inherit pkgs myFont; })
    # (import ../../../../shared/home/software/work/default.nix { inherit pkgs; })
    ./software/aerospace.nix
  ];

  home = {
    # Shared Work
    file."./.config/pip/pip.conf".source = "${../../../../shared/home/files/work/pip.conf}";
    file."./.codex/config.toml".source = "${../../../../shared/home/files/work/codex-config.toml}";
    # Shared Personal
    # Shared Common
    file."./.config/opencode/opencode.json".source = "${../../../../shared/home/files/common/opencode-config.json}";
    file."./.ssh/config".source = "${../../../../shared/home/files/common/ssh-config.darwin}";
    file."./.condarc".source = "${../../../../shared/home/files/common/.condarc}";
    file.".p10k.zsh".source = "${../../../../shared/home/files/common/.p10k.zsh}";
    # Platform specific
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
