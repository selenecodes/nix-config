{
  bifrost.keys = [
    {
      name = "qwen3.8-gayming";
      value = "";
      models = ["qwen3.8:27b"];
      weight = 1.0;
      vllm_key_config = {
        url = "http://10.10.50.10:8000";
        model_name = "qwen3.8:27b";
      };
    }
  ];

  opencode.models = {
    "qwen3.8:27b" = {
      name = "Qwen 3.8 27B";
      tool_call = true;
      reasoning = true;
      options.reasoningEffort = "medium";
      variants = {
        xhigh.reasoningEffort = "xhigh";
        medium.reasoningEffort = "medium";
        low.reasoningEffort = "low";
      };
    };
  };

  vllm = {
    image = "vllm/vllm-openai:latest";
    cmd = [
      "--model"
      "unsloth/Qwen3.8-27B-NVFP4"
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
      "--override-generation-config"
      ''{"temperature": 1.0, "top_p": 0.95, "top_k": 20, "min_p": 0.0, "presence_penalty": 0.0, "repetition_penalty": 1.0}''
      "--enable-auto-tool-choice"
      "--tool-call-parser"
      "qwen3_xml"
      "--served-model-name"
      "qwen3.8:27b"
    ];
  };
}
