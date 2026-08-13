{lib, ...}: let
  models = {
    "qwen3.6:27b-128k" = ./modelfiles/qwen3.6-27b-modelfile;
  };
  sanitize = model: lib.replaceStrings [":" "." "/"] ["-" "-" "-"] model;
in {
  nixos.base = {
    config,
    pkgs,
    ...
  }: {
    services.ollama = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 11434;
      package =
        if config.hardware.nvidia.modesetting.enable
        then pkgs.ollama-cuda
        else pkgs.ollama;
    };

    systemd.services = lib.mapAttrs' (model: modelfile:
      lib.nameValuePair "ollama-model-${sanitize model}" {
        description = "Build the ${model} Ollama model";
        after = ["ollama.service"];
        requires = ["ollama.service"];
        environment = {
          OLLAMA_HOST = "127.0.0.1:11434";
          HOME = "/var/lib/ollama";
        };
        path = [config.services.ollama.package pkgs.curl];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "ollama";
        };
        script = ''
          until curl --fail --silent http://127.0.0.1:11434/api/version >/dev/null; do
            sleep 1
          done

          if ollama show ${model} >/dev/null 2>&1; then
            echo "Model ${model} already present, skipping"
            exit 0
          fi

          ollama create ${model} --file ${modelfile}
        '';
      })
    models;

    # Force a re-check of every model on every switch, since systemd
    # won't re-run a oneshot just because its unit file is unchanged.
    system.activationScripts.ollamaModelRebuild = {
      text = lib.concatMapStringsSep "\n" (model: ''
        systemctl restart --no-block ollama-model-${sanitize model}.service || true
      '') (lib.attrNames models);
      deps = [];
    };
  };
}
