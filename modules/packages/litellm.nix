_: {
  homeManager.work = {
    config,
    lib,
    pkgs,
    ...
  }: let
    localApiKey = "sk-litellm-local";
    upstreamBaseUrl = "https://apim.datalab-01.azure.grid.rws.nl/openai/v1";
    litellmPackage = pkgs.litellm.overridePythonAttrs (oldAttrs: {
      dependencies = lib.filter (dependency: (dependency.pname or null) != "a2a-sdk") oldAttrs.dependencies;
    });
    litellmConfig = pkgs.writeText "litellm-config.yaml" ''
      model_list:
        - model_name: gpt-5.1
          litellm_params:
            model: openai/gpt-5.1
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN
        - model_name: gpt-5.4
          litellm_params:
            model: openai/gpt-5.4
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN
        - model_name: gpt-5.5
          litellm_params:
            model: openai/gpt-5.5
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN
        - model_name: gpt-5.6-luna
          litellm_params:
            model: openai/gpt-5.6-luna
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN
        - model_name: gpt-5.6-sol
          litellm_params:
            model: openai/gpt-5.6-sol
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN
        - model_name: gpt-5.6-terra
          litellm_params:
            model: openai/gpt-5.6-terra
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN
        - model_name: text-embedding-3-large
          litellm_params:
            model: openai/text-embedding-3-large
            api_base: ${upstreamBaseUrl}
            api_key: os.environ/AOAI_UPSTREAM_TOKEN

      general_settings:
        master_key: os.environ/LITELLM_MASTER_KEY
    '';
    refreshScript = pkgs.writeShellScript "litellm-refresh-token" ''
      export PATH="/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:$PATH"

      while true; do
        token=$(az account get-access-token \
          --resource https://cognitiveservices.azure.com/ \
          --query accessToken \
          --output tsv) || {
          sleep 30
          continue
        }

        export AOAI_UPSTREAM_TOKEN="$token"
        export LITELLM_MASTER_KEY=${localApiKey}
        ${pkgs.coreutils}/bin/timeout 45m ${lib.getExe litellmPackage} \
          --config ${litellmConfig} \
          --port 4000

        sleep 5
      done
    '';
  in {
    home.packages = [litellmPackage];

    home.sessionVariables.LITELLM_TOKEN = "Bearer ${localApiKey}";

    home.file.".config/litellm/config.yaml".source = litellmConfig;

    systemd.user.services.litellm = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "LiteLLM Azure APIM proxy";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
        ExecStart = refreshScript;
        Restart = "always";
        RestartSec = 5;
      };
      Install.WantedBy = ["default.target"];
    };

    launchd.agents.litellm = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = ["${refreshScript}"];
        EnvironmentVariables = {
          PATH = "/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:/usr/bin:/bin";
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
