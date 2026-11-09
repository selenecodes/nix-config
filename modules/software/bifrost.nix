{
  inputs,
  lib,
  ...
}: let
  catalog = import ../../lib/ai {inherit lib;};
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
          bifrostVersion = "2.5.0";
          bifrostPkgs =
            pkgs
            // {
              go_1_27 = pkgs.go_1_27.overrideAttrs (_: {
                version = "1.27.3";
                src = pkgs.fetchurl {
                  url = "https://go.dev/dl/go1.27.3.src.tar.gz";
                  sha256 = "6e7749035cf360f06b2575d162ea79df9fda8ef671889e5c375f8e50777f26bb";
                };
              });
            };
          bifrostUi = pkgs.callPackage "${inputs.bifrost}/nix/packages/bifrost-ui.nix" {
            pkgs =
              pkgs
              // {
                buildNpmPackage = args:
                  pkgs.buildNpmPackage (args
                    // {
                      npmDepsHash = "sha256-JtaSXBfz7toZ8gF9Jjq5iveV/b5obQNhA9VvjyvDky0=";
                    });
              };
            version = bifrostVersion;
            src = inputs.bifrost;
          };
          bifrostHttp =
            (pkgs.callPackage "${inputs.bifrost}/nix/packages/bifrost-http.nix" {
              pkgs = bifrostPkgs;
              version = bifrostVersion;
              inputs = inputs.bifrost.inputs;
              src = inputs.bifrost;
              "bifrost-ui" = bifrostUi;
            }).overrideAttrs (_: {
              vendorHash = "sha256-+8BZjZl1KZGzBlTQL/C16mC4pWrqOl6x10FxF4InBFQ=";
            });
        in {
          imports = [
            {
              imports = [../../lib/home-manager/bifrost];
              programs.bifrost = {
                enable = true;
                package = bifrostHttp;
                adminPasswordFile = "${config.home.homeDirectory}/.local/share/bifrost/admin-password";
                settings = {
                  "$schema" = "https://www.getbifrost.ai/schema";
                  client.enforce_auth_on_inference = false;
                  governance.auth_config = {
                    is_enabled = true;
                    admin_username = "admin";
                    admin_password = "env.BIFROST_ADMIN_PASSWORD";
                  };
                  providers = catalog.bifrost.providers;
                  mcp = {
                    tool_manager_config.disable_auto_tool_inject = true;
                    client_configs = [
                      {
                        name = "context7";
                        connection_type = "http";
                        connection_string = "https://mcp.context7.com/mcp";
                        tools_to_execute = ["*"];
                      }
                      {
                        name = "gh_grep";
                        connection_type = "http";
                        connection_string = "https://mcp.grep.app";
                        tools_to_execute = ["*"];
                      }
                    ];
                  };
                };
              };
            }
          ];
        };
      };
    }
  ];
}
