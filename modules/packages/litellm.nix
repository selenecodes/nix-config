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
    responseCostCallback = pkgs.writeText "litellm_response_cost_callback.py" ''
      from litellm.integrations.custom_logger import CustomLogger

      class ResponseCostCallback(CustomLogger):
          async def async_post_call_success_hook(self, data, user_api_key_dict, response):
              hidden_params = getattr(response, "_hidden_params", {}) or {}
              cost = hidden_params.get("response_cost")
              if cost is None:
                  return response

              usage = getattr(response, "usage", None)
              if usage is None:
                  return response

              if isinstance(usage, dict):
                  usage["cost"] = cost
              else:
                  setattr(usage, "cost", cost)

              return response


      proxy_handler_instance = ResponseCostCallback()
    '';
    litellmConfigYaml = pkgs.writeText "litellm-config.yaml" ''
      model_list:
        - model_name: gpt-5.1
          litellm_params:
            model: azure/gpt-5.1
            api_base: ${upstreamBaseUrl}
          model_info:
            input_cost_per_token: 1.38e-06
            output_cost_per_token: 1.1e-05
            cache_read_input_token_cost: 1.4e-07
        - model_name: gpt-5.4
          litellm_params:
            model: azure/gpt-5.4
            api_base: ${upstreamBaseUrl}
          model_info:
            cache_read_input_token_cost: 2.8e-07
            cache_read_input_token_cost_above_272k_tokens: 5e-07
            cache_read_input_token_cost_priority: 5.5e-07
            cache_read_input_token_cost_above_272k_tokens_priority: 1e-06
            input_cost_per_token: 2.75e-06
            input_cost_per_token_above_272k_tokens: 5e-06
            input_cost_per_token_priority: 5.5e-06
            input_cost_per_token_above_272k_tokens_priority: 1e-05
            output_cost_per_token: 1.65e-05
            output_cost_per_token_above_272k_tokens: 2.25e-05
            output_cost_per_token_priority: 3.3e-05
            output_cost_per_token_above_272k_tokens_priority: 4.5e-05
        - model_name: gpt-5.5
          litellm_params:
            model: azure/gpt-5.5
            api_base: ${upstreamBaseUrl}
          model_info:
            input_cost_per_token: 5.5e-06
            cache_read_input_token_cost: 5.5e-07
            output_cost_per_token: 3.3e-05
            input_cost_per_token_priority: 1.375e-05
            cache_read_input_token_cost_priority: 1.38e-06
            output_cost_per_token_priority: 8.25e-05
            input_cost_per_token_above_272k_tokens: 1.1e-05
            cache_read_input_token_cost_above_272k_tokens: 1.1e-06
            output_cost_per_token_above_272k_tokens: 4.95e-05
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
          model_info:
            input_cost_per_token: 1.43e-07

      litellm_settings:
        enable_azure_ad_token_refresh: true
        callbacks: ["litellm_response_cost_callback.proxy_handler_instance"]

      general_settings:
        master_key: os.environ/LITELLM_MASTER_KEY
    '';
    litellmConfigDir = pkgs.runCommand "litellm-config-dir" {} ''
      mkdir -p $out
      cp ${litellmConfigYaml} $out/litellm-config.yaml
      cp ${responseCostCallback} $out/litellm_response_cost_callback.py
    '';
    startScript = pkgs.writeShellScript "litellm-start" ''
      export PATH="/opt/homebrew/bin:/usr/local/bin:/run/current-system/sw/bin:$PATH"

      # kill anything still bound to our port from a previous generation/run
      ${pkgs.lsof}/bin/lsof -tiTCP:${litellmPort} -sTCP:LISTEN | xargs -r kill -9

      exec ${lib.getExe litellmPackage} \
        --config ${litellmConfigDir}/litellm-config.yaml \
        --port ${litellmPort}
    '';
  in {
    home.packages = [litellmPackage];

    home.sessionVariables.LITELLM_API_KEY = localApiKey;

    home.file.".config/litellm/config.yaml".source = litellmConfigDir + "/litellm-config.yaml";

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
