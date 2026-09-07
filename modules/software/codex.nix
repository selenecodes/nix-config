{lib, ...}: let
  catalog = import ../../lib/ai {inherit lib;};
  topology = import ../../lib/ai/topology.nix;
in {
  # codex is managed through npm; a mock package lets home-manager manage
  # settings without trying to install the package itself.
  repository.features = [
    {
      homeManager = {
        targets = ["studio" "rwslaptop"];
        module = {
          lib,
          pkgs,
          ...
        }: {
          programs.zsh.initContent = lib.mkAfter ''
            codex_sig() {
              local token
              token="$(sigrid_mcp_token)" || return
              SIGRID_MCP_TOKEN="$token" command codex \
                -c 'mcp_servers.sigrid.url="https://sigrid-says.com/mcp"' \
                -c 'mcp_servers.sigrid.bearer_token_env_var="SIGRID_MCP_TOKEN"' \
                "$@"
            }
          '';

          programs.codex = {
            enable = true;
            package = pkgs.codex;
            settings = {
              model = catalog.models."eu/gpt-5.6-luna".name;
              model_provider = "bifrost";
              model_reasoning_effort = "medium";
              model_providers.bifrost = {
                name = "Bifrost (proxy)";
                base_url = topology.bifrost.baseUrl;
                wire_api = "responses";
                model_reasoning_effort = "medium";
              };
            };
          };
        };
      };
    }
  ];
}
