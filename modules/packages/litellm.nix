{lib, ...}: let
  upstreamBaseUrl = "https://apim.datalab-01.azure.grid.rws.nl/";
  modelConfig = import ../../lib/litellm-models.nix {inherit upstreamBaseUrl lib;};
in {
  homeManager.work = {
    config,
    lib,
    pkgs,
    ...
  }: let
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
      ${modelConfig.litellmModelList}

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

      export LITELLM_MASTER_KEY="$(${pkgs._1password-cli}/bin/op item get "LiteLLM" --field master_key --reveal)"

      # kill anything still bound to our port from a previous generation/run
      ${pkgs.lsof}/bin/lsof -tiTCP:${litellmPort} -sTCP:LISTEN | xargs -r kill -9

      exec ${lib.getExe litellmPackage} \
        --config ${litellmConfigDir}/litellm-config.yaml \
        --host 127.0.0.1 \
        --port ${litellmPort}
    '';
  in {
    home.packages = [litellmPackage];

    programs.zsh.initContent = lib.mkAfter ''
      litellm_master_key() {
        command op item get "LiteLLM" --field master_key --reveal
      }
    '';

    home.file.".config/litellm/config.yaml".source = litellmConfigDir + "/litellm-config.yaml";

    systemd.user.services.litellm = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "LiteLLM Azure APIM proxy";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };
      Service = {
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
