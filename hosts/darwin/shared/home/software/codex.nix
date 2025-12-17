{ pkgs, ... }: {
  programs.codex = {
    enable = true;
    package = pkgs.codex;
    settings = {
      model = "gpt-5";
      model_provider = "azure";
      model_reasoning_effort = "high";
      model_providers = {
        azure = {
          name = "Azure";
          base_url = "https://apim.datalab-01.azure.grid.rws.nl/openai/v1";
          env_http_headers = {
            Authorization = "AOAI_TOKEN";
          };
          wire_api = "responses";
          model_reasoning_effort = "high";
        };
      };
    };
  };
}
