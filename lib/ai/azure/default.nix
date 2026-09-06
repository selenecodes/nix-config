{lib}: let
  ai = import ../lib.nix {inherit lib;};
  models = [
    (import ./gpt-5.1.nix {inherit (ai) mkAiModel;})
    (import ./gpt-5.4.nix {inherit (ai) mkAiModel;})
    (import ./gpt-5.5.nix {inherit (ai) mkAiModel;})
    (import ./gpt-5.6-luna.nix {inherit (ai) mkAiModel;})
    (import ./gpt-5.6-sol.nix {inherit (ai) mkAiModel;})
    (import ./gpt-5.6-terra.nix {inherit (ai) mkAiModel;})
    (import ./text-embedding-3-large.nix {inherit (ai) mkAiModel;})
  ];
in
  ai.mkAiProvider {
    name = "azure";
    inherit models;
    local = false;
    bifrost = {
      keys = [
        {
          name = "azure-default-credential";
          value = "";
          models = map (model: model.name) models;
          weight = 1.0;
          aliases = builtins.listToAttrs (map (model: {
              inherit (model) name;
              value = model.providerModel;
            })
            models);
          azure_key_config.endpoint = "https://apim.datalab-01.azure.grid.rws.nl/";
        }
      ];
    };
  }
