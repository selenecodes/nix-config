{lib}: let
  ai = import ../lib.nix {inherit lib;};
  topology = import ../topology.nix;
  qwen = import ./qwen3.8-27b.nix {inherit (ai) mkAiModel;};
in
  ai.mkAiProvider {
    name = "vllm";
    models = [qwen];
    local = true;
    activeModel = qwen;
    bifrost = {
      keys = [
        {
          name = "vllm-local-model";
          value = "";
          models = [qwen.name];
          weight = 1.0;
          vllm_key_config = {
            url = topology.vllm.url;
            model_name = qwen.name;
          };
        }
      ];
    };
  }
