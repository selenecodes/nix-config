{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6-astra";
  providerModel = "gpt-6-astra";
  version = "2026-09-03";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  cost = {
    input = 11.0;
    output = 55.0;
    cacheRead = 1.1;
    contextOver200k = {
      input = 22.0;
      output = 82.5;
      cacheRead = 2.2;
    };
  };
}
