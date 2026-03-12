{ pkgs, ... }:
# Add ghostty mock since we're managing it through npm
let
  codex-mock = pkgs.writeShellScriptBin "codex-mock" ''
    true
    '';
in {
  programs.codex = {
    enable = true;
    package = codex-mock;
    settings = {
      model = "gpt-5.1";
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
