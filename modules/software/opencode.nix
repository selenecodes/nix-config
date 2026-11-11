{lib, ...}: let
  catalog = import ../../lib/ai {inherit lib;};
  topology = import ../../lib/ai/topology.nix;
in {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {
          config,
          pkgs,
          ...
        }: let
          defaultModel = "bifrost/eu/gpt-6.1-sol";
          isLinux = pkgs.stdenv.hostPlatform.isLinux;
          opencodePackage =
            if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" && pkgs.opencode.version == "2.2.5"
            then
              pkgs.opencode.overrideAttrs (old: {
                # Correct the dependency hash for the pinned Apple Silicon build.
                node_modules = old.node_modules.overrideAttrs (_: {
                  outputHash = "sha256-dIveiaiPFGSItwLyeMuPDxTE9gpvvnlTCB/+nG24qCc=";
                });
              })
            else pkgs.opencode;
          gitlabPython = pkgs.python3.withPackages (ps: [ps.mcp ps.httpx2 ps.truststore]);
          gitlabBridge = pkgs.writeShellScript "gitlab-mcp-bridge" ''
            exec ${gitlabPython}/bin/python ${../../lib/ai/gitlab-mcp-bridge.py}
          '';
        in {
          programs.zsh.initContent = lib.mkAfter (builtins.replaceStrings
            ["@jq@" "@gitlabBridge@"]
            ["${pkgs.jq}/bin/jq" "${gitlabBridge}"]
            (builtins.readFile ../../lib/ai/opencode-with.zsh));

          catppuccin.opencode.enable = false;
          programs.opencode = {
            enable = true;
            package = opencodePackage;
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
              mcp.servers.gitlab = {
                type = "local";
                command = ["${gitlabBridge}"];
                disabled = true;
                environment = {
                  GITLAB_PAT = "{env:GITLAB_PAT}";
                  GITLAB_CLIENT_CERT = "${config.home.homeDirectory}/certs/gitlab-at-rws-nl-cert/git-rws-nl-mtls.pem";
                };
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
