let
  registryTokenItem = "RWS UV Registry Token";
  registryTokenField = "password";
in
  _: {
    repository.features = [
      {
        nixos = {
          targets = ["*"];
          module = {pkgs, ...}: {
            environment.localBinInPath = true;
            programs.nix-ld = {
              enable = true;
              libraries = with pkgs; [
                stdenv.cc.cc.lib
                zlib
                openssl
                libffi
                glibc
              ];
            };
          };
        };

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
                python-preference = "only-managed";
              };
            };

            home.sessionVariables.SSL_CLIENT_CERT = "${config.home.homeDirectory}/certs/gitlab-at-rws-nl-cert/git-rws-nl-mtls.pem";

            programs.zsh.initContent = lib.mkAfter ''
              if [[ -r "$HOME/.config/uv/rws-index-url" ]]; then
                export UV_DEFAULT_INDEX="$(<"$HOME/.config/uv/rws-index-url")"
              fi
            '';

            home.activation.storeUvRegistryToken = lib.hm.dag.entryAfter ["writeBoundary"] ''
              rws_uv_registry_file="$HOME/.config/uv/rws-index-url"
              if rws_uv_registry_token="$(command ${pkgs._1password-cli}/bin/op item get ${lib.escapeShellArg registryTokenItem} --field ${lib.escapeShellArg registryTokenField} --reveal)"; then
                (
                  umask 077
                  ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$rws_uv_registry_file")"
                  ${pkgs.coreutils}/bin/printf '%s' "https://__token__:$rws_uv_registry_token@gitlab.at.rws.nl/api/v4/projects/4478/packages/pypi/simple" > "$rws_uv_registry_file.tmp"
                  ${pkgs.coreutils}/bin/mv "$rws_uv_registry_file.tmp" "$rws_uv_registry_file"
                )
              fi
              unset rws_uv_registry_file rws_uv_registry_token
            '';
          };
        };
      }
    ];
  }
