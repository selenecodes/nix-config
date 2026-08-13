{lib, ...}: let
  modelConfig = import ../../lib/llm-models.nix {inherit lib;};
in {
  homeManager.base = {
    lib,
    pkgs,
    ...
  }: {
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
        enabled_providers = ["bifrost" "ollama"];
        model = "ollama/qwen3.6:27b-128k";
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
          models = modelConfig.opencodeModels.bifrost;
          options = {
            baseURL = "http://127.0.0.1:4000/v1";
            apiKey = "";
          };
        };
        provider.ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (gayming)";
          options.baseURL = "http://10.10.50.10:11434/v1";
          models = modelConfig.opencodeModels.ollama;
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
      tui.theme = "catppuccin";
    };
  };
}
