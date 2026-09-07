{lib}: let
  providers = [
    (import ./azure {inherit lib;})
    (import ./vllm {inherit lib;})
  ];
  allModels = lib.concatMap (provider: provider.models) providers;
  routableModels = lib.concatMap (provider:
    if provider.local
    then [provider.activeModel]
    else provider.models)
  providers;
  mapCost = cost:
    {
      inherit (cost) input output;
    }
    // lib.optionalAttrs (cost ? cacheRead) {cache_read = cost.cacheRead;}
    // lib.optionalAttrs (cost ? contextOver200k) {context_over_200k = mapCost cost.contextOver200k;};
  toOpenCodeModel = model:
    {
      name = model.displayName;
      reasoning = model.capabilities.reasoning;
      tool_call = model.capabilities.toolCall;
      limit = {context = model.limits.context;} // lib.optionalAttrs (model.limits.output != null) {output = model.limits.output;};
    }
    // lib.optionalAttrs (model.cost != null) {cost = mapCost model.cost;}
    // lib.optionalAttrs (model.reasoningEfforts != null) {
      options.reasoningEffort = "medium";
      variants = builtins.listToAttrs (map (reasoningEffort: {
          name = reasoningEffort;
          value.reasoningEffort = reasoningEffort;
        })
        model.reasoningEfforts);
    };
in {
  inherit providers allModels routableModels;
  models = builtins.listToAttrs (map (model: {
      inherit (model) name;
      value = model;
    })
    allModels);
  bifrost.providers = builtins.listToAttrs (map (provider: {
      inherit (provider) name;
      value = provider.bifrost;
    })
    providers);
  opencode.models = builtins.listToAttrs (map (model: {
      inherit (model) name;
      value = toOpenCodeModel model;
    })
    routableModels);
  vllm.activeModel = (lib.findFirst (provider: provider.name == "vllm") null providers).activeModel;
}
