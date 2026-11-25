_: {
  repository.features = [
    {
      darwin = {
        targets = ["*"];
        module = {
          homebrew.casks = ["zed"];
          launchd.user.envVariables.BIFROST_API_KEY = "dummy";
        };
      };
      homeManager = {
        targets = ["*"];
        module = {
          pkgs,
          pkgsStable,
          ...
        }: let
          myFont = "JetBrainsMono Nerd Font";
          fontSize = 16.0;
        in {
          programs.zed-editor = {
            enable = true;
            enableMcpIntegration = true;
            package =
              if pkgs.stdenv.hostPlatform.isDarwin
              then null
              else pkgs.zed-editor;
            defaultEditor = false;

            extensions = [
              "toml"
              "helm"
              "dockerfile"
              "docker-compose"
              "svelte"
              "mdx"
              "nix"
              "terraform"
              "mermaid"
              "just"
              "ruff"
              "pyrefly"
            ];

            userSettings = {
              # Fonts
              ui_font_family = myFont;
              buffer_font_family = myFont;
              buffer_font_size = fontSize;
              buffer_font_features.calt = true;
              terminal = {
                font_family = myFont;
                font_size = fontSize;
                font_features.calt = true;
              };

              # AI (kept on, since Bifrost is configured below)
              disable_ai = false;
              telemetry = {
                diagnostics = false;
                metrics = false;
              };

              # Keymap / editor behaviour
              base_keymap = "Atom";
              multi_cursor_modifier = "cmd_or_ctrl";
              wrap_guides = [80];
              show_wrap_guides = true;
              diagnostics.inline.enabled = true;
              lsp_document_colors = "background";
              code_lens = "on";
              suggest_extensions = false;

              # Panels
              project_panel = {
                dock = "left";
                button = true;
                drag_and_drop = true;
              };
              git_panel.dock = "left";
              agent = {
                dock = "right";
                default_model = {
                  provider = "Bifrost";
                  model = "azure/eu/gpt-6-luna";
                };
              };
              collaboration_panel.button = false;

              # File associations
              file_types = {
                HCL = ["*.hcl" "*.tf" "*.tfvars"];
                YAML = ["*.yml"];
                "Shell Script" = ["*.env"];
              };

              # Language settings
              languages = {
                Python = {
                  language_servers = ["pyrefly" "ruff" "!pyright" "!basedpyright" "!ty" "..."];
                  formatter.language_server.name = "ruff";
                };
                Markdown.remove_trailing_whitespace_on_save = true;
              };
              lsp = {
                pyrefly.binary = {
                  path = "${pkgsStable.pyrefly}/bin/pyrefly";
                  arguments = ["lsp"];
                };
                nil.binary.path = "${pkgs.nil}/bin/nil";
              };

              # AI Config
              language_models.openai_compatible."Bifrost" = {
                api_url = "http://localhost:4000/v1";
                available_models =
                  map (id: {
                    name = id;
                    display_name = id;
                    max_tokens = 922000;
                    max_output_tokens = 128000;
                    capabilities = {
                      tools = true;
                      images = true;
                      parallel_tool_calls = true;
                      prompt_cache_key = false;
                    };
                  }) [
                    "azure/eu/gpt-6-astra"
                    "azure/eu/gpt-6-luna"
                    "azure/eu/gpt-6-sol"
                    "azure/eu/gpt-6.1-sol"
                    "azure/eu/gpt-6.1-terra"
                  ];
              };

              edit_predictions = {
                provider = "open_ai_compatible_api";
                open_ai_compatible_api = {
                  api_url = "http://localhost:4000/v1/completions";
                  model = "azure/eu/gpt-6-luna";
                  prompt_format = "infer";
                  max_output_tokens = 64;
                };
              };
            };
          };
        };
      };
    }
  ];
}
