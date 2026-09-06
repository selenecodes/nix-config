{lib, ...}: let
  catalog = import ../../lib/ai {inherit lib;};
  model = catalog.vllm.activeModel;
  topology = import ../../lib/ai/topology.nix;
  port = topology.vllm.port;
  backendPort = 8001;
  idleTimeout = "15min";
  idleTimeoutSeconds = 15 * 60;
in {
  repository.features = [
    {
      nixos = {
        targets = ["gayming"];
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

            cmd =
              [
                "--host"
                "0.0.0.0"
                "--port"
                (toString port)
                "--model"
                model.providerModel
                "--max-model-len"
                (toString model.limits.context)
                "--served-model-name"
                model.name
              ]
              ++ model.vllm.args;
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
