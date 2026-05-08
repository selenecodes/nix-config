{ pkgs, myFont, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "svelte"
      "python"
      "yaml"
      "dockerfile"
      "terraform"
      "just"
      "mermaid"
    ];
    userSettings = {
      # Font
      buffer_font_family = myFont;
      buffer_font_size = 13;
      buffer_font_features = {
        calt = true;
      };
      # No direct letter_spacing equivalent; Zed uses font features/metrics

      # Terminal
      terminal = {
        font_family = myFont;
        font_size = 13;
        font_features = {
          calt = true;
        };
      };

      # Editor behavior
      format_on_paste = "on";
      soft_wrap = "none";
      rulers = [{ column = 80; }];
      multi_cursor_modifier = "cmd_or_ctrl";
      scroll_sensitivity = 1.0;

      # Telemetry
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      # Git
      git = {
        git_gutter = "tracked_files";
        inline_blame.enabled = true;
      };

      # File associations
      file_types = {
        HCL = ["*.hcl" "*.tf" "*.tfvars"];
        YAML = ["*.yml"];
        "Shell Script" = ["*.env"];
      };

      # Language-specific settings
      languages = {
        Python = {
          language_servers = ["pyright" "ruff"];
          formatter = {
            language_server = { name = "ruff"; };
          };
        };
      };

      # Theme - NOT CONFIGURED HERE, SET IN modules/profiles/common/home/software/catppuccin.nix

      # Make comments italic via syntax theme overrides
      experimental.theme_overrides.syntax = {
        comment = { font_style = "italic"; };
        "comment.doc" = { font_style = "italic"; };
      };
    };
  };
}
