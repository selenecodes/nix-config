{lib, ...}: let
  modelConfig = import ../../lib/litellm-models.nix {
    inherit lib;
    upstreamBaseUrl = null;
  };
in {
  homeManager.work = {pkgs, ...}: {
    catppuccin.opencode.enable = false;
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
      settings = {
        plugin = ["opencode-plugin-litellm@0.7.0"];
        enabled_providers = ["litellm"];
        model = "litellm/gpt-5.6-luna";
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
        provider.litellm = {
          npm = "@ai-sdk/openai-compatible";
          name = "LiteLLM (proxy)";
          models = modelConfig.opencodeModels;
          options = {
            baseURL = "http://127.0.0.1:4000/v1";
            apiKey = "{env:LITELLM_API_KEY}";
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
          sigrid-says = {
            type = "remote";
            url = "https://sigrid-says.com/mcp";
            headers.Authorization = "Bearer {env:SIGRID_MCP_TOKEN}";
          };
        };
      };
      tui.theme = "catppuccin";
    };
  };
}
