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
  vllm.activeModel = (lib.findFirst (provider: provider.name == "vllm") null providers).activeModel;
}
