{inputs, ...}: let
  azure = import ../../lib/ai/models/azure.nix;
  qwen = import ../../lib/ai/models/qwen3-8-27b.nix;
  topology = import ../../lib/ai/topology.nix;
in {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {pkgs, ...}: let
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
                  providers = {
                    azure = azure.bifrost;
                    vllm.keys = [
                      {
                        name = "qwen3.8-gayming";
                        value = "";
                        models = [qwen.servedName];
                        weight = 1.0;
                        vllm_key_config = {
                          url = topology.vllm.url;
                          model_name = qwen.servedName;
                        };
                      }
                    ];
                  };
                };
              };
            }
          ];
        };
      };
    }
  ];
}
