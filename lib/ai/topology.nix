{lib}: let
  azure = import ./models/azure.nix;
  qwen3-8-27b = import ./models/qwen3-8-27b.nix;
in {
  bifrost.providers = {
    azure = azure.bifrost;
    vllm = qwen3-8-27b.bifrost;
  };

  opencode = {
    bifrost.models = lib.filterAttrs (_: model: model.tool_call or false) azure.opencode.models;
    vllm = qwen3-8-27b.opencode;
  };

  inherit (azure) codex;
  inherit (qwen3-8-27b) vllm;
}
