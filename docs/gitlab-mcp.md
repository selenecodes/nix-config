# GitLab MCP with mTLS

`opencode --with gitlab` connects OpenCode directly to
`https://gitlab.at.rws.nl/api/v4/mcp`, bypassing Bifrost. OpenCode starts a local
stdio bridge which uses the MCP Python SDK's Streamable HTTP transport with
the client certificate and PAT. No local network listener is opened.

Ensure the new files are tracked by Git (Nix flakes omit untracked files).
Apply the Home Manager configuration (on this Mac, `just build studio`), then
open a new shell and run:

```sh
opencode --with gitlab
opencode --with sigrid --with gitlab
opencode --with sigrid,gitlab
```

The launcher retrieves the PAT from the **RWS Gitlab** 1Password item's **mcp**
field, using `gitlab_mcp_token`, just like the Sigrid launcher. Approve any
1Password authentication request. Run `/mcps` and check that `gitlab` is
connected before using its tools. The launcher uses `--standalone` because
the shared OpenCode service cannot inherit a new invocation's credentials.
Normal `opencode` launches leave GitLab disabled. `--with` is provided by your
Zsh wrapper, not the upstream CLI. Other arguments are forwarded unchanged;
`--` stops wrapper option parsing. Repeated integrations are loaded only once.
The existing `opencode_sig` and `opencode_gitlab` shortcuts still work.

The default certificate is
`~/certs/gitlab-at-rws-nl-cert/git-rws-nl-mtls.pem`. It must contain the
certificate chain and its unencrypted private key, as in the working curl
setup. To use another path:

```sh
GITLAB_CLIENT_CERT=/path/to/client.pem opencode --with gitlab
```

The PAT is supplied only through the standalone process environment; it is
not saved in configuration, shell history, or the Nix store. The private key
stays in the existing PEM file. Protect it with restrictive file permissions.
Environment credentials are still accessible to sufficiently privileged local
processes. Avoid shell tracing (`set -x`) when launching with secrets.

Server-certificate verification remains enabled, using the operating system
trust store. Ensure your corporate CA is trusted and your VPN/network route
is available. A live connection requires your PAT and has not been verified
by automated tests; never paste the PAT into an agent conversation.

## Offline tests

From the repository root:

```sh
nix shell --impure --expr 'let f = builtins.getFlake (toString ./.); p = f.darwinConfigurations.studio.pkgs; in p.python3.withPackages (ps: [ps.mcp ps.httpx2 ps.truststore ps.trustme])' --command python -B -m unittest discover -s tests -p 'test_gitlab_mcp_bridge.py' -v
```

These tests use fake HTTP responses and a local TLS server with generated
certificates; they do not use the real certificate or contact GitLab.

Test the launcher separately (requires Python, Zsh, and jq):

```sh
python3 -B -m unittest discover -s tests -p 'test_opencode_with.py' -v
```

Launcher tests use fake OpenCode and credential helpers, not 1Password.
