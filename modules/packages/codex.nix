_: {
  # codex is managed through npm; a mock package lets home-manager manage
  # settings without trying to install the package itself.
  homeManager.work = {
    lib,
    pkgs,
    ...
  }: {
    programs.zsh.initContent = lib.mkAfter ''
      codex_litellm() {
        local key token
        key="$(litellm_master_key)" || return
        token="$(sigrid_mcp_token)" || return
        LITELLM_API_KEY="$key" SIGRID_MCP_TOKEN="$token" command codex "$@"
      }
    '';

    programs.codex = {
      enable = true;
      package = pkgs.codex;
      settings = {
        model = "gpt-5.6-luna";
        model_provider = "azure";
        model_reasoning_effort = "medium";
        mcp_servers = {
          sigrid = {
            url = "https://sigrid-says.com/mcp";
            bearer_token_env_var = "SIGRID_MCP_TOKEN";
          };
        };
        model_providers = {
          azure = {
            name = "Azure";
            base_url = "http://127.0.0.1:4000/v1";
            env_key = "LITELLM_API_KEY";
            wire_api = "responses";
            model_reasoning_effort = "medium";
          };
        };
      };
    };
  };
}
