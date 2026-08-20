{inputs, ...}: {
  homeManager.work = {pkgs, ...}: let
    bifrostVersion = "1.6.10";
    bifrostUi = pkgs.callPackage "${inputs.bifrost}/nix/packages/bifrost-ui.nix" {
      pkgs =
        pkgs
        // {
          buildNpmPackage = args:
            pkgs.buildNpmPackage (args
              // {
                npmDepsHash = "sha256-aM+yPpvVoc0UtMcJH4hhJWHfApAkBcKdJB+EbI3BFCA=";
              });
        };
      version = bifrostVersion;
      src = inputs.bifrost;
    };
    bifrostHttp =
      (pkgs.callPackage "${inputs.bifrost}/nix/packages/bifrost-http.nix" {
        version = bifrostVersion;
        inputs = inputs.bifrost.inputs;
        src = inputs.bifrost;
        "bifrost-ui" = bifrostUi;
      }).overrideAttrs (_: {
        vendorHash = "sha256-RYmCtKoyh93LxkiVPIWnDslohzW5s2Mr0jvg2F7i/nQ=";
      });
  in {
    imports = [
      {
        imports = [../../lib/home-manager/bifrost];
        programs.bifrost = {
          enable = true;
          package = bifrostHttp;
          settings = {
            "$schema" = "https://www.getbifrost.ai/schema";
            providers.azure.keys = [
              {
                name = "azure-default-credential";
                value = "";
                models = ["eu/gpt-5.1" "eu/gpt-5.4" "eu/gpt-5.5" "eu/gpt-5.6-luna" "eu/gpt-5.6-sol" "eu/gpt-5.6-terra" "text-embedding-3-large"];
                weight = 1.0;
                aliases = {
                  "eu/gpt-5.1" = "gpt-5.1";
                  "eu/gpt-5.4" = "gpt-5.4";
                  "eu/gpt-5.5" = "gpt-5.5";
                  "eu/gpt-5.6-luna" = "gpt-5.6-luna";
                  "eu/gpt-5.6-sol" = "gpt-5.6-sol";
                  "eu/gpt-5.6-terra" = "gpt-5.6-terra";
                  "text-embedding-3-large" = "text-embedding-3-large";
                };
                azure_key_config.endpoint = "https://apim.datalab-01.azure.grid.rws.nl/";
              }
            ];
            providers.vllm.keys = [
              {
                name = "qwen3.8-gayming";
                value = "";
                models = ["qwen3.8:27b"];
                weight = 1.0;
                vllm_key_config = {
                  url = "http://10.10.50.10:8000";
                  model_name = "qwen3.8:27b";
                };
              }
            ];
          };
        };
      }
    ];
  };
}
