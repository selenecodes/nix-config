_: {
  homeManager.work = {pkgs, ...}: {
    catppuccin.opencode.enable = false;
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
      settings = {
        plugin = ["opencode-plugin-litellm@latest"];
        enabled_providers = ["litellm"];
        model = "litellm/gpt-5.6-luna";
        provider.litellm = {
          npm = "@ai-sdk/openai-compatible";
          name = "LiteLLM (proxy)";
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
