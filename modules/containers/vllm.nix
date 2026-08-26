_: let
  port = 8000;
  backendPort = 8001;
  idleTimeout = "15min";
  idleTimeoutSeconds = 15 * 60;
in {
  nixos.base = {pkgs, ...}: {
    virtualisation.oci-containers.containers.vllm = {
      image = "vllm/vllm-openai:latest";
      autoStart = false;

      # The socket-activated proxy owns the public port.
      ports = ["127.0.0.1:${toString backendPort}:${toString port}"];

      volumes = [
        "vllm_cache:/root/.cache/huggingface"
      ];

      extraOptions = [
        "--device=nvidia.com/gpu=all"
        "--ipc=host"
      ];

      environment = {
        PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True";
        MAX_JOBS = "2";
      };

      cmd = [
        "--model"
        "gittensor-model-hub/Qwen3.8-27B-NVFP4-RTX5090"
        "--host"
        "0.0.0.0"
        "--port"
        (toString port)
        "--quantization"
        "modelopt"
        "--kv-cache-dtype"
        "fp8"
        "--trust-remote-code"
        "--max-model-len"
        "100000"
        "--max-num-seqs"
        "16"
        "--gpu-memory-utilization"
        "0.8"
        "--reasoning-parser"
        "qwen3"
        "--enable-auto-tool-choice"
        "--tool-call-parser"
        "qwen3_xml"
        "--served-model-name"
        "qwen3.8:27b"
      ];
    };

    systemd.sockets.vllm = {
      wantedBy = ["sockets.target"];
      socketConfig = {
        ListenStream = port;
        Accept = true;
        Service = "vllm-proxy@.service";
      };
    };

    systemd.services."vllm-proxy@" = {
      requires = ["docker-vllm.service"];
      after = ["docker-vllm.service"];
      serviceConfig = {
        ExecStartPre = [
          "${pkgs.coreutils}/bin/touch /run/vllm-last-request"
          "${pkgs.bash}/bin/bash -c 'until ${pkgs.curl}/bin/curl --fail --silent --output /dev/null http://127.0.0.1:${toString backendPort}/health; do sleep 1; done'"
        ];
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:${toString backendPort}";
        TimeoutStartSec = "10min";
      };
    };

    systemd.services.vllm-idle-stop = {
      serviceConfig.Type = "oneshot";
      script = ''
        if ${pkgs.systemd}/bin/systemctl is-active --quiet 'vllm-proxy@*.service'; then
          exit 0
        fi

        if [ -e /run/vllm-last-request ]; then
          now="$(${pkgs.coreutils}/bin/date +%s)"
          lastRequest="$(${pkgs.coreutils}/bin/date -r /run/vllm-last-request +%s)"
          if [ "$((now - lastRequest))" -ge ${toString idleTimeoutSeconds} ]; then
            ${pkgs.systemd}/bin/systemctl stop docker-vllm.service
          fi
        fi
      '';
    };

    systemd.timers.vllm-idle-stop = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = idleTimeout;
        OnUnitActiveSec = "1min";
      };
    };
  };
}
