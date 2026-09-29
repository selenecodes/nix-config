let
  registryTokenItem = "RWS UV Registry Token";
  registryTokenField = "password";
  registryIndexUrl = "https://gitlab.at.rws.nl/api/v4/projects/4478/packages/pypi/simple";
in
  _: {
    repository.features = [
      {
        homeManager = {
          targets = ["*"];
          module = {
            config,
            lib,
            pkgs,
            ...
          }: {
            programs.uv = {
              enable = true;
              settings = {
                preview-features = ["native-auth"];
                python-preference = "only-managed";
                index = [
                  {
                    name = "rws";
                    url = registryIndexUrl;
                    default = true;
                    authenticate = "always";
                  }
                ];
              };
            };

            home.sessionVariables.SSL_CLIENT_CERT = "${config.home.homeDirectory}/certs/gitlab-at-rws-nl-cert/git-rws-nl-mtls.pem";

            home.activation.storeUvRegistryToken = lib.hm.dag.entryAfter ["writeBoundary"] ''
              if rws_uv_registry_token="$(command op item get ${lib.escapeShellArg registryTokenItem} --field ${lib.escapeShellArg registryTokenField} --reveal)"; then
                if printf '%s' "$rws_uv_registry_token" | UV_PREVIEW_FEATURES=native-auth ${pkgs.uv}/bin/uv auth login "${registryIndexUrl}" --token -; then
                  ${pkgs.coreutils}/bin/rm -f "$HOME/.zshrc.uv-registry-token"
                fi
              fi
              unset rws_uv_registry_token
            '';
          };
        };
      }
    ];
  }
