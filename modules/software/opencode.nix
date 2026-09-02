_: let
  azure = import ../../lib/ai/models/azure.nix;
  qwen = import ../../lib/ai/models/qwen3-8-27b.nix;
  topology = import ../../lib/ai/topology.nix;
in {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {
          lib,
          pkgs,
          ...
        }: let
          defaultModel = "bifrost/eu/gpt-5.6-terra";
          isLinux = pkgs.stdenv.hostPlatform.isLinux;
        in {
          programs.zsh.initContent = lib.mkAfter ''
            opencode_sig() {
              local token
              token="$(sigrid_mcp_token)" || return
              OPENCODE_CONFIG_CONTENT='{"mcp":{"sigrid-says":{"type":"remote","url":"https://sigrid-says.com/mcp","headers":{"Authorization":"Bearer {env:SIGRID_MCP_TOKEN}"}}}}' \
                SIGRID_MCP_TOKEN="$token" command opencode "$@"
            }
          '';

          catppuccin.opencode.enable = false;
          programs.opencode = {
            enable = true;
            package = pkgs.opencode;
            settings = {
              enabled_providers = ["bifrost" "vllm"];
              model = defaultModel;
              agent = {
                build = {
                  model = defaultModel;
                };
                plan = {
                  model = defaultModel;
                };
              };
              share = "disabled";
              lsp = true;
              formatter = {
                alejandra = {
                  command = ["alejandra" "$FILE"];
                  extensions = [".nix"];
                };
                nixfmt.disabled = true;
                ruff = {};
                uv = {};
              };
              provider.bifrost = {
                npm = "@ai-sdk/openai";
                name = "Bifrost (proxy)";
                models = lib.filterAttrs (_: model: model.tool_call or false) azure.opencode.models;
                options = {
                  baseURL = topology.bifrost.baseUrl;
                  apiKey = "";
                };
              };
              provider.vllm = {
                npm = "@ai-sdk/openai-compatible";
                name = "vLLM (gayming)";
                options.baseURL = topology.vllm.baseUrl;
                models.${qwen.servedName} = {
                  inherit (qwen) name;
                  tool_call = qwen.capabilities.toolCall;
                  reasoning = qwen.capabilities.reasoning;
                  options.reasoningEffort = "medium";
                  variants = {
                    xhigh.reasoningEffort = "xhigh";
                    medium.reasoningEffort = "medium";
                    low.reasoningEffort = "low";
                  };
                };
              };
              mcp = {
                context7 = {
                  type = "remote";
                  url = "https://mcp.context7.com/mcp";
                };
                gh_grep = {
                  type = "remote";
                  url = "https://mcp.grep.app";
                };
              };
            };
            tui.theme =
              if isLinux
              then "system"
              else "catppuccin";
          };
        };
      };
    }
  ];
}
