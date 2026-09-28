_: {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {lib, ...}: {
          programs.uv = {
            enable = true;
          };

          programs.zsh.initContent = lib.mkAfter ''
            if rws_uv_registry_token="$(command op item get "RWS UV Registry Token" --field password --reveal)"; then
              export UV_DEFAULT_INDEX="https://__token__:$rws_uv_registry_token@gitlab.at.rws.nl/api/v4/projects/4478/packages/pypi/simple"
            fi

            rws_uv_client_certificate="$HOME/certs/gitlab-at-rws-nl-cert/git-rws-nl-mtls.pem"
            if [[ -r "$rws_uv_client_certificate" ]]; then
              export SSL_CLIENT_CERT="$rws_uv_client_certificate"
            fi
            unset rws_uv_registry_token
            unset rws_uv_client_certificate
          '';
        };
      };
    }
  ];
}
