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
        module = {pkgs, ...}: let
          bifrostVersion = "2.4.0";
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
                      npmDepsHash = "sha256-GBxwxHmvAlMMS9WtTC7ITLvLNuLjcE8IxaHbHXd7qM8=";
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
              vendorHash = "sha256-MoHp3GW29L1dF2Eh/1T7FrDdavdVINsLF8sItT1ZTQE=";
            });
        in {
          imports = [
            {
              imports = [../../lib/home-manager/bifrost];
              programs.bifrost = {
                enable = true;
                package = bifrostHttp;
                settings = {
                  "$schema" = "https://www.getbifrost.ai/schema";
                  providers = catalog.bifrost.providers;
                };
              };
            }
          ];
        };
      };
    }
  ];
}
