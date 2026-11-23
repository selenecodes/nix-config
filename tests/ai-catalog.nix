{lib}: let
  catalog = import ../lib/ai {inherit lib;};
  localModels = builtins.filter (entry: entry.vllm != null) catalog.routableModels;
in {
  testAzureProviderModel = {
    expr = catalog.models."eu/gpt-6-sol".providerModel;
    expected = "gpt-6-sol";
  };
  testLocalProviderModel = {
    expr = catalog.models."qwen3.8:27b".providerModel;
    expected = "unsloth/Qwen3.8-27B-NVFP4";
  };
  testBifrostAzureAlias = {
    expr = (builtins.head catalog.bifrost.providers.azure.keys).aliases."eu/gpt-6-sol";
    expected = "gpt-6-sol";
  };
  testQwenServingContextUnchanged = {
    expr = catalog.vllm.activeModel.limits.context;
    expected = 131072;
  };
  testSingleLocalModel = {
    expr = builtins.length localModels;
    expected = 1;
  };
  testLocalModelIsActive = {
    expr = (builtins.head localModels).name;
    expected = catalog.vllm.activeModel.name;
  };
}
