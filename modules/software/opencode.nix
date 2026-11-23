{inputs, ...}: let
  topology = import ../../lib/ai/topology.nix;
in {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {pkgs, ...}: let
          defaultModel = "bifrost/azure/gpt-6.1-sol";
          isLinux = pkgs.stdenv.hostPlatform.isLinux;
          opencodePackage = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
        in {
          catppuccin.opencode.enable = false;
          programs.opencode = {
            enable = true;
            package = opencodePackage;
            settings = {
              "$schema" = "https://opencode.ai/config.json";
              policies = [
                {
                  action = "provider.use";
                  resource = "*";
                  effect = "deny";
                }
                {
                  action = "provider.use";
                  resource = "bifrost";
                  effect = "allow";
                }
              ];
              plugins = ["opencode-models-discovery@2.2.1"];
              model = defaultModel;
              agents = {
                build = {
                  model = defaultModel;
                };
                plan = {
                  model = defaultModel;
                };
              };
              share = "disabled";
              lsp = true;
              formatter = {
                alejandra = {
                  command = ["alejandra" "$FILE"];
                  extensions = [".nix"];
                };
                nixfmt.disabled = true;
                ruff = {};
                uv = {};
              };
              providers.bifrost = {
                package = "@opencode/ai/providers/openai";
                name = "Bifrost (proxy)";
                settings = {
                  baseURL = topology.bifrost.baseUrl;
                  apiKey = "";
                  modelsDiscovery = {
                    enabled = true;
                    modelInfoFormat = "bifrost";
                    smartModelName = true;
                  };
                };
              };
              mcp.servers.bifrost = {
                type = "remote";
                url = topology.bifrost.mcpUrl;
              };
            };
            cli.theme.name =
              if isLinux
              then "system"
              else "catppuccin";
          };
        };
      };
    }
  ];
}
