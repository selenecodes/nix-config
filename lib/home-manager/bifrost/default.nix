{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.bifrost;
  bifrostLib = import ./lib.nix {inherit lib;};
  configFile =
    if cfg.settings == null
    then null
    else bifrostLib.mkConfig pkgs cfg.settings;
  startScript = pkgs.writeShellScript "bifrost-start" ''
    export PATH="/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:$PATH"
    ${pkgs.lsof}/bin/lsof -tiTCP:${toString cfg.port} -sTCP:LISTEN | xargs -r kill -9
    mkdir -p ${lib.escapeShellArg (toString cfg.appDir)}
    ${lib.optionalString (configFile != null) ''
      install -m 600 ${configFile} ${lib.escapeShellArg (toString cfg.appDir)}/config.json
    ''}
    exec ${lib.getExe cfg.package} ${lib.escapeShellArgs (bifrostLib.mkArgs cfg)}
  '';
in {
  imports = [./options.nix];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package != null;
        message = "programs.bifrost.package must be set when programs.bifrost.enable is true.";
      }
    ];
    home.packages = [cfg.package];

    systemd.user.services.bifrost = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      Unit = {
        Description = "Bifrost AI gateway";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
        ExecStart = "${startScript}";
        Restart = "always";
        RestartSec = 5;
        Environment = [
          "AZURE_TOKEN_CREDENTIALS=AzureCLICredential"
        ];
      };
      Install.WantedBy = ["default.target"];
    };

    launchd.agents.bifrost = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      enable = true;
      config = {
        ProgramArguments = ["${startScript}"];
        EnvironmentVariables = {
          PATH = "/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:/usr/bin:/bin";
          HOME = config.home.homeDirectory;
          AZURE_TOKEN_CREDENTIALS = "AzureCLICredential";
          # Prevent 'az' from hanging on background prompts/checks
          AZURE_CORE_COLLECT_TELEMETRY = "false";
          AZURE_CORE_NO_COLOR = "true";
          AZURE_CORE_ONLY_SHOW_ERRORS = "true";
        };
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/bifrost.err.log";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/bifrost.out.log";
      };
    };
  };
}
