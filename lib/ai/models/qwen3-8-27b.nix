let
  servedName = "qwen3.8:27b";
  source = "unsloth/Qwen3.8-27B-NVFP4";
  quantization = "modelopt";
  limits = {
    context = 131072;
    sequences = 16;
  };
in {
  name = "Qwen 3.8 27B";
  inherit servedName source quantization limits;

  capabilities = {
    reasoning = true;
    toolCall = true;
  };

  vllmArgs = [
    "--model"
    source
    "--quantization"
    quantization
    "--kv-cache-dtype"
    "fp8"
    "--trust-remote-code"
    "--max-model-len"
    (toString limits.context)
    "--max-num-seqs"
    (toString limits.sequences)
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
    servedName
  ];
}
