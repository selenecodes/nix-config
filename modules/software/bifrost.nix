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
          bifrostVersion = "2.0.0";
          bifrostUi = pkgs.callPackage "${inputs.bifrost}/nix/packages/bifrost-ui.nix" {
            pkgs =
              pkgs
              // {
                buildNpmPackage = args:
                  pkgs.buildNpmPackage (args
                    // {
                      npmDepsHash = "sha256-cOswnT4ZahWX66h9oiw4t3r5GZeOH/yjbnTCAsjVgnw=";
                    });
              };
            version = bifrostVersion;
            src = inputs.bifrost;
          };
          bifrostHttp =
            (pkgs.callPackage "${inputs.bifrost}/nix/packages/bifrost-http.nix" {
              version = bifrostVersion;
              inputs = inputs.bifrost.inputs;
              src = inputs.bifrost;
              "bifrost-ui" = bifrostUi;
            }).overrideAttrs (_: {
              vendorHash = "sha256-JGOMV5R9d+gG5sB9SUmm219Vl/HM0/6EryAWAj2UnVU=";
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
