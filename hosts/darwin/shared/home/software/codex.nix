{ pkgs, ... }:
# Add codex mock since we're managing it through npm and the
# pkgs.codex is at a version above 0.5.55 which doesn't work with Azure OpenAI
let
  codex-mock = pkgs.writeShellScriptBin "codex-mock" ''
    true
    '';
in {
  programs.codex = {
    enable = true;
    package = codex-mock;
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
