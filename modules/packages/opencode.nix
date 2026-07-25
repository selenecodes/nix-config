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
        plugin = ["opencode-plugin-litellm@latest"];
        enabled_providers = ["litellm"];
        model = "litellm/gpt-5.6-luna";
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
      };
      tui.theme = "catppuccin";
    };
  };
}
