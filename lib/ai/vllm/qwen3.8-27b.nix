{mkAiModel}:
mkAiModel {
  name = "qwen3.8:27b";
  providerModel = "unsloth/Qwen3.8-27B-NVFP4";
  displayName = "Qwen 3.8 27B";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 131072;
    output = 131072;
  };
  reasoningEfforts = ["xhigh" "medium" "low"];
  vllm.args = [
    "--quantization"
    "modelopt"
    "--kv-cache-dtype"
    "fp8"
    "--trust-remote-code"
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
  ];
}
