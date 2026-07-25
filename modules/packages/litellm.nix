_: {
  homeManager.work = {
    config,
    lib,
    pkgs,
    ...
  }: let
    localApiKey = "sk-litellm-local";
    upstreamBaseUrl = "https://apim.datalab-01.azure.grid.rws.nl/";
    litellmPort = "4000";
    litellmPackage = pkgs.litellm.overridePythonAttrs (oldAttrs: {
      dependencies = lib.filter (dependency: (dependency.pname or null) != "a2a-sdk") oldAttrs.dependencies;
    });
    litellmConfig = pkgs.writeText "litellm-config.yaml" ''
      model_list:
        - model_name: gpt-5.1
          litellm_params:
            model: azure/gpt-5.1
            api_base: ${upstreamBaseUrl}
        - model_name: gpt-5.4
          litellm_params:
            model: azure/gpt-5.4
            api_base: ${upstreamBaseUrl}
        - model_name: gpt-5.5
          litellm_params:
            model: azure/gpt-5.5
            api_base: ${upstreamBaseUrl}
        - model_name: gpt-5.6-luna
          litellm_params:
            model: azure/gpt-5.6-luna
            api_base: ${upstreamBaseUrl}
        - model_name: gpt-5.6-sol
          litellm_params:
            model: azure/gpt-5.6-sol
            api_base: ${upstreamBaseUrl}
        - model_name: gpt-5.6-terra
          litellm_params:
            model: azure/gpt-5.6-terra
            api_base: ${upstreamBaseUrl}
        - model_name: text-embedding-3-large
          litellm_params:
            model: azure/text-embedding-3-large
            api_base: ${upstreamBaseUrl}

      litellm_settings:
        enable_azure_ad_token_refresh: true

      general_settings:
        master_key: os.environ/LITELLM_MASTER_KEY
    '';
    startScript = pkgs.writeShellScript "litellm-start" ''
      export PATH="/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:$PATH"

      # kill anything still bound to our port from a previous generation/run
      ${pkgs.lsof}/bin/lsof -tiTCP:${litellmPort} -sTCP:LISTEN | xargs -r kill -9

      exec ${lib.getExe litellmPackage} \
        --config ${litellmConfig} \
        --port ${litellmPort}
    '';
  in {
    home.packages = [litellmPackage];

    home.sessionVariables.LITELLM_API_KEY = localApiKey;

    home.file.".config/litellm/config.yaml".source = litellmConfig;

    systemd.user.services.litellm = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "LiteLLM Azure APIM proxy";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
        Environment = ["LITELLM_MASTER_KEY=${localApiKey}"];
        ExecStart = "${startScript}";
        Restart = "always";
        RestartSec = 5;
      };
      Install.WantedBy = ["default.target"];
    };

    launchd.agents.litellm = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = ["${startScript}"];
        EnvironmentVariables = {
          PATH = "/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:/usr/bin:/bin";
          LITELLM_MASTER_KEY = localApiKey;
        };
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Background";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/litellm.err.log";
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/litellm.out.log";
      };
    };
  };
}
