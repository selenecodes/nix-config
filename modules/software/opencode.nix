{lib, ...}: let
  catalog = import ../../lib/ai {inherit lib;};
  topology = import ../../lib/ai/topology.nix;
in {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {pkgs, ...}: let
          defaultModel = "bifrost/eu/gpt-6.1-sol";
          isLinux = pkgs.stdenv.hostPlatform.isLinux;
        in {
          programs.zsh.initContent = lib.mkAfter ''
            opencode_sig() {
              local token
              token="$(sigrid_mcp_token)" || return
              OPENCODE_CONFIG_CONTENT='{"mcp":{"sigrid-says":{"type":"remote","url":"https://sigrid-says.com/mcp","headers":{"Authorization":"Bearer {env:SIGRID_MCP_TOKEN}"}}}}' \
                SIGRID_MCP_TOKEN="$token" command opencode "$@"
            }
          '';

          catppuccin.opencode.enable = false;
          programs.opencode = {
            enable = true;
            package = pkgs.opencode;
            settings = {
              enabled_providers = ["bifrost"];
              model = defaultModel;
              agent = {
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
              provider.bifrost = {
                npm = "@ai-sdk/openai";
                name = "Bifrost (proxy)";
                models = catalog.opencode.models;
                options = {
                  baseURL = topology.bifrost.baseUrl;
                  apiKey = "";
                };
              };
              mcp.bifrost = {
                type = "remote";
                url = topology.bifrost.mcpUrl;
              };
            };
            tui.theme =
              if isLinux
              then "system"
              else "catppuccin";
          };
        };
      };
    }
  ];
}
