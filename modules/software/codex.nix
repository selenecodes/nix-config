{lib, ...}: let
  ai = import ../../lib/ai/topology.nix {inherit lib;};
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
            settings = ai.codex;
          };
        };
      };
    }
  ];
}
