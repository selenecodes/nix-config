{lib}: let
  root = ../..;
  ai = import (root + "/lib/ai/lib.nix") {inherit lib;};
  catalog = import (root + "/lib/ai") {inherit lib;};
  invalidModel =
    !(builtins.tryEval
      (ai.mkAiModel {
        name = "missing-provider-model";
        displayName = "Invalid";
        capabilities = {
          reasoning = false;
          toolCall = false;
        };
        limits.context = 1;
      }).name).success;
  localModels = builtins.filter (model: model.vllm != null) catalog.routableModels;
in
  assert invalidModel;
  assert catalog.models."eu/gpt-5.6-sol".providerModel == "gpt-5.6-sol";
  assert catalog.models."qwen3.8:27b".providerModel == "unsloth/Qwen3.8-27B-NVFP4";
  assert (builtins.elemAt catalog.bifrost.providers.azure.keys 0).aliases."eu/gpt-5.6-sol" == "gpt-5.6-sol";
  assert catalog.opencode.models."qwen3.8:27b".name == "Qwen 3.8 27B";
  assert catalog.opencode.models."qwen3.8:27b".variants.xhigh.reasoningEffort == "xhigh";
  assert builtins.length localModels == 1;
  assert (builtins.head localModels).name == catalog.vllm.activeModel.name; true
