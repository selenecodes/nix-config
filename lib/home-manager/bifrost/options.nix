{
  config,
  lib,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
in {
  options.programs.bifrost = {
    enable = lib.mkEnableOption "Bifrost AI gateway";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "The Bifrost HTTP gateway package.";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 4000;
    };
    appDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/.local/share/bifrost";
    };
    logLevel = lib.mkOption {
      type = lib.types.enum ["debug" "info" "warn" "error"];
      default = "info";
    };
    logStyle = lib.mkOption {
      type = lib.types.enum ["json" "pretty"];
      default = "pretty";
    };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    settings = lib.mkOption {
      type = lib.types.nullOr jsonFormat.type;
      default = null;
      description = ''
        Optional contents of Bifrost's config.json. When null, Bifrost can be
        configured entirely through its UI and persistent config database.
      '';
    };
  };
}
