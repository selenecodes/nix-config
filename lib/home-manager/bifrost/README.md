# Bifrost dashboard access

The repository configures dashboard authentication with username `admin`.
Inference remains unauthenticated, and Bifrost listens on `127.0.0.1:4000`.

Before activating the configuration, create
`~/.local/share/bifrost/admin-password` with your chosen password on one line.
Keep this file outside the repository and the Nix store. Restrict its permissions:

```sh
mkdir -p ~/.local/share/bifrost
chmod 700 ~/.local/share/bifrost
# Create admin-password with your editor, then:
chmod 600 ~/.local/share/bifrost/admin-password
```

After activation, open <http://127.0.0.1:4000> and log in as `admin`.
The service refuses to start if the password file is missing or empty.
To change the password, edit the file and restart Bifrost. File configuration
overrides existing database credentials, and a password change invalidates
existing sessions.

Bifrost 2.2.6 introduced the management API setup lock. Without an enabled admin
account, dashboard API requests require a setup token. This configuration
provisions the admin through `governance.auth_config`, so no setup token is
needed. The old `setup-token` file is no longer read or generated.
