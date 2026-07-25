_: {
  homeManager.work = {pkgs, ...}: {
    catppuccin.opencode.enable = false;
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
      settings = {
        enabled_providers = ["litellm"];
        model = "litellm/gpt-5.6-luna";
        provider.litellm = {
          npm = "@ai-sdk/openai-compatible";
          name = "LiteLLM";
          options = {
            baseURL = "http://127.0.0.1:4000/v1";
            apiKey = "{env:LITELLM_API_KEY}";
          };
          models = {
            "gpt-5.1".name = "GPT-5.1";
            "gpt-5.4".name = "GPT-5.4";
            "gpt-5.5".name = "GPT-5.5";
            "gpt-5.6-luna".name = "GPT-5.6 Luna";
            "gpt-5.6-sol".name = "GPT-5.6 Sol";
            "gpt-5.6-terra".name = "GPT-5.6 Terra";
            "text-embedding-3-large".name = "Text Embedding 3 Large";
          };
        };
      };
      tui.theme = "catppuccin";
    };
  };
}
