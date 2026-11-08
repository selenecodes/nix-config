{lib}: let
  requireString = name: value:
    assert lib.assertMsg (value != null) "AI definition requires ${name}";
    assert value != "";
    assert lib.assertMsg (lib.types.str.check value) "AI definition requires ${name} to be a string"; true;
in {
  # Required arguments: name, providerModel, displayName, capabilities.reasoning,
  # capabilities.toolCall, limits.context, and limits.output. Optional arguments:
  # cost, reasoningEfforts, and vllm.args.
  #
  # Model naming:
  # - name is the stable name used by OpenCode, Bifrost, and local vLLM serving.
  # - providerModel is the provider's underlying model reference. E.g. the Azure name or the Huggingface name. 
  # - displayName is a humanized name, shown in various tools such as OpenCode.
  #
  # Hosted Azure example:
  #   name = "eu/gpt-6-sol";
  #   providerModel = "gpt-6-sol";
  #   displayName = "GPT 6 Sol";
  #
  # Local vLLM example:
  #   name = "qwen3.8:27b";
  #   providerModel = "unsloth/Qwen3.8-27B-NVFP4";
  #   displayName = "My local model"
  #   vllm.args = [ "--quantization" "modelopt" ];
  mkAiModel = model: let
    capabilities = model.capabilities or null;
    limits = model.limits or null;
    vllm = model.vllm or null;
  in
    assert requireString "model.name" (model.name or null);
    assert requireString "model.providerModel" (model.providerModel or null);
    assert requireString "model.displayName" (model.displayName or null);
    assert lib.assertMsg (builtins.isAttrs capabilities) "AI definition requires capabilities to be an attribute set";
    assert lib.assertMsg (lib.types.bool.check (capabilities.reasoning or null)) "AI definition requires model.capabilities.reasoning to be a boolean";
    assert lib.assertMsg (lib.types.bool.check (capabilities.toolCall or null)) "AI definition requires model.capabilities.toolCall to be a boolean";
    assert lib.assertMsg (builtins.isAttrs limits) "AI definition requires limits to be an attribute set";
    assert lib.assertMsg (lib.types.ints.positive.check (limits.context or null)) "AI definition requires model.limits.context to be a positive integer";
    assert lib.assertMsg (lib.types.ints.positive.check (limits.output or null)) "AI definition requires model.limits.output to be a positive integer";
    assert lib.assertMsg (!(model ? reasoningEfforts) || builtins.isList model.reasoningEfforts && lib.all builtins.isString model.reasoningEfforts) "AI model reasoningEfforts must be a list of strings";
    assert lib.assertMsg (vllm == null || builtins.isAttrs vllm && builtins.isList (vllm.args or null)) "AI model vllm.args must be a list when vllm is present";
      model
      // {
        cost = model.cost or null;
        reasoningEfforts = model.reasoningEfforts or null;
        inherit vllm;
      };

  mkAiProvider = provider: let
    models = provider.models or null;
    activeModel = provider.activeModel or null;
    local = provider.local or false;
  in
    assert requireString "provider.name" (provider.name or null);
    assert lib.assertMsg (builtins.isList models && models != []) "AI provider ${provider.name or "<unknown>"} requires models";
    assert lib.assertMsg (builtins.isAttrs (provider.bifrost or null)) "AI definition requires provider.bifrost to be an attribute set";
    assert provider.bifrost != {};
    assert lib.assertMsg (lib.types.bool.check local) "AI definition requires provider.local to be a boolean";
    assert lib.assertMsg (!local || activeModel != null) "Local AI provider ${provider.name} requires activeModel";
    assert lib.assertMsg (!local || lib.elem activeModel models) "Local AI provider ${provider.name} activeModel must be registered";
      provider // {inherit models activeModel local;};
}
