_: let
  port = 8000;
  backendPort = 8001;
  idleTimeout = "15min";
  idleTimeoutSeconds = 15 * 60;
in {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          networking.firewall.allowedTCPPorts = [8000];
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
              "unsloth/Qwen3.8-27B-NVFP4"
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
              "131072"
              "--max-num-seqs"
              "16"
              "--gpu-memory-utilization"
              "0.8"
              "--reasoning-parser"
              "qwen3"
              # Unsloths' recommended defaults for thinking mode. Clients can override
              # these per request, including with the instruct-mode profile.
              "--override-generation-config"
              ''{"temperature": 1.0, "top_p": 0.95, "top_k": 20, "min_p": 0.0, "presence_penalty": 0.0, "repetition_penalty": 1.0}''
              "--enable-auto-tool-choice"
              "--tool-call-parser"
              "qwen3_xml"
              "--served-model-name"
              "qwen3.8:27b"
            ];
          };

          systemd = {
            sockets.vllm = {
              wantedBy = ["sockets.target"];
              socketConfig = {
                ListenStream = port;
                Accept = true;
              };
            };

            services = {
              "vllm@" = {
                requires = ["docker-vllm.service"];
                after = ["docker-vllm.service"];
                serviceConfig = {
                  StandardInput = "socket";
                  StandardOutput = "socket";

                  # Use < /dev/null so curl/bash don't accidentally consume the incoming HTTP request bytes
                  ExecStartPre = [
                    "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/touch /run/vllm-last-request < /dev/null'"
                    "${pkgs.bash}/bin/bash -c 'until ${pkgs.curl}/bin/curl --fail --silent --output /dev/null http://127.0.0.1:${toString backendPort}/health; do sleep 1; done < /dev/null'"
                  ];
                  ExecStart = "${pkgs.socat}/bin/socat STDIO TCP4:127.0.0.1:${toString backendPort}";
                  TimeoutStartSec = "10min";
                };
              };

              vllm-idle-stop = {
                serviceConfig.Type = "oneshot";
                script = ''
                  if ${pkgs.systemd}/bin/systemctl is-active --quiet 'vllm@*.service'; then
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
            };

            timers.vllm-idle-stop = {
              wantedBy = ["timers.target"];
              timerConfig = {
                OnBootSec = idleTimeout;
                OnUnitActiveSec = "1min";
              };
            };
          };
        };
      };
    }
  ];
}
