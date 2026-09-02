_: {
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
              model = "eu/gpt-5.6-luna";
              model_provider = "bifrost";
              model_reasoning_effort = "medium";
              model_providers = {
                bifrost = {
                  name = "Bifrost (proxy)";
                  base_url = "http://127.0.0.1:4000/v1";
                  wire_api = "responses";
                  model_reasoning_effort = "medium";
                };
              };
            };
          };
        };
      };
    }
  ];
}
