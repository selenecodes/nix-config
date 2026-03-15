{ lib, ... }:

{
  imports = [
    ./software/aerospace.nix
  ];

  home = {
    # Shared Work
    file."./.config/pip/pip.conf".source = "${../../../../modules/profiles/work/home/files/pip.conf}";
    file."./.codex/config.toml".source = "${../../../../modules/profiles/work/home/files/codex-config.toml}";
    # Shared Common
    file."./.config/opencode/opencode.json".source = "${../../../../modules/profiles/common/home/files/opencode-config.json}";
    file."./.condarc".source = "${../../../../modules/profiles/common/home/files/.condarc}";
    file.".p10k.zsh".source = "${../../../../modules/profiles/common/home/files/.p10k.zsh}";
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
