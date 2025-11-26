{ pkgs, ... }: {
  programs.codex = {
    enable = true;
    settings = {
      model = "gpt-5";
      model_provider = "azure";
      model_reasoning_effort = "high";
      model_providers = {
        azure = {
          name = "Azure";
          base_url = "https://apim.datalab-01.azure.grid.rws.nl/openai/deployments/gpt-5";
          env_http_headers = {
            Authorization = "AOAI_TOKEN";
          };
          query_params = {
            "api-version" = "2025-01-01-preview";
          };
          wire_api = "chat";
          model_reasoning_effort = "high";
        };
      };
    };
  };
}
