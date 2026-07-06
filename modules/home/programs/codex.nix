{ pkgs, lib, isWork ? false, ... }:
# codex is managed through npm; a mock package lets home-manager manage
# settings without trying to install the package itself.
lib.mkIf isWork (
  let
    codex-mock = pkgs.writeShellScriptBin "codex-mock" ''
      true
    '';
  in {
    programs.codex = {
      enable = true;
      package = codex-mock;
      settings = {
        model = "gpt-5.5";
        model_provider = "azure";
        model_reasoning_effort = "medium";
        model_providers = {
          azure = {
            name = "Azure";
            base_url = "https://apim.datalab-01.azure.grid.rws.nl/openai/v1";
            env_http_headers = {
              Authorization = "AOAI_TOKEN";
            };
            wire_api = "responses";
            model_reasoning_effort = "medium";
          };
        };
      };
    };
  }
)
