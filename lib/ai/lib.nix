{lib}: let
  require = name: value:
    assert lib.assertMsg (value != null) "AI definition requires ${name}"; value;
  requireAttrs = name: value:
    assert lib.assertMsg (builtins.isAttrs value) "AI definition requires ${name} to be an attribute set"; value;
  requireString = name: value:
    assert require name value != "";
    assert lib.assertMsg (builtins.isString value) "AI definition requires ${name} to be a string"; value;
  requireBool = name: value:
    assert lib.assertMsg (builtins.isBool value) "AI definition requires ${name} to be a boolean"; true;
  requireInt = name: value:
    assert lib.assertMsg (builtins.isInt value && value > 0) "AI definition requires ${name} to be a positive integer"; value;
in {
  # Required arguments: name, providerModel, displayName, capabilities.reasoning,
  # capabilities.toolCall, and limits.context. Optional arguments: limits.output,
  # cost, reasoningEfforts, and vllm.args.
  #
  # Model naming:
  # - name is the stable name used by OpenCode, Bifrost, and local vLLM serving.
  # - providerModel is the provider's underlying model reference.
  # - displayName is shown to people in OpenCode.
  #
  # Hosted Azure example:
  #   name = "eu/gpt-5.6-sol";
  #   providerModel = "gpt-5.6-sol";
  #   displayName = "GPT 5.6 Sol";
  #
  # Local vLLM example:
  #   name = "qwen3.8:27b";
  #   providerModel = "unsloth/Qwen3.8-27B-NVFP4";
  #   vllm.args = [ "--quantization" "modelopt" ];
  mkAiModel = model: let
    capabilities = requireAttrs "capabilities" (model.capabilities or null);
    limits = requireAttrs "limits" (model.limits or null);
    vllm = model.vllm or null;
  in
    assert requireString "model.name" (model.name or null) != "";
    assert requireString "model.providerModel" (model.providerModel or null) != "";
    assert requireString "model.displayName" (model.displayName or null) != "";
    assert requireBool "model.capabilities.reasoning" (capabilities.reasoning or null);
    assert requireBool "model.capabilities.toolCall" (capabilities.toolCall or null);
    assert requireInt "model.limits.context" (limits.context or null) > 0;
    assert lib.assertMsg (limits.output or null == null || builtins.isInt limits.output && limits.output > 0) "AI model limits.output must be null or a positive integer";
    assert lib.assertMsg (!(model ? reasoningEfforts) || builtins.isList model.reasoningEfforts && lib.all builtins.isString model.reasoningEfforts) "AI model reasoningEfforts must be a list of strings";
    assert lib.assertMsg (vllm == null || builtins.isAttrs vllm && builtins.isList (vllm.args or null)) "AI model vllm.args must be a list when vllm is present";
      model
      // {
        limits = limits // {output = limits.output or null;};
        cost = model.cost or null;
        reasoningEfforts = model.reasoningEfforts or null;
        inherit vllm;
      };

  mkAiProvider = provider: let
    models = provider.models or null;
    activeModel = provider.activeModel or null;
    local = provider.local or false;
  in
    assert requireString "provider.name" (provider.name or null) != "";
    assert lib.assertMsg (builtins.isList models && models != []) "AI provider ${provider.name or "<unknown>"} requires models";
    assert requireAttrs "provider.bifrost" (provider.bifrost or null) != {};
    assert requireBool "provider.local" local;
    assert lib.assertMsg (!local || activeModel != null) "Local AI provider ${provider.name} requires activeModel";
    assert lib.assertMsg (!local || lib.elem activeModel models) "Local AI provider ${provider.name} activeModel must be registered";
      provider // {inherit models activeModel local;};
}
