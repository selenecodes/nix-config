_: {
  nixos.base = {
    virtualisation.oci-containers.containers.vllm = {
      image = "vllm/vllm-openai:latest";
      autoStart = true;
      
      ports = ["8000:8000"];
      
      # Use a named Docker/Podman volume instead of a host bind mount
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
        "8000"
        "--quantization"
        "modelopt"
        "--kv-cache-dtype"
        "fp8"
        "--trust-remote-code"
        "--max-model-len"
        "147456"
        "--max-num-seqs"
        "16"
        "--gpu-memory-utilization"
        "0.84"
        "--reasoning-parser"
        "qwen3"
        "--enable-auto-tool-choice"
        "--tool-call-parser"
        "qwen3_xml"
        "--served-model-name"
        "qwen3.8:27b"
      ];
    };
  };
}
