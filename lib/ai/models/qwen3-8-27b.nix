{
  name = "Qwen 3.8 27B";
  servedName = "qwen3.8:27b";
  source = "unsloth/Qwen3.8-27B-NVFP4";
  quantization = "modelopt";

  capabilities = {
    reasoning = true;
    toolCall = true;
  };

  limits = {
    context = 131072;
    sequences = 16;
  };
}
