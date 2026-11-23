{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6-luna";
  providerModel = "gpt-6-luna";
  version = "2026-09-22";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  cost = {
    input = 0.12;
    output = 0.6;
    cacheRead = 0.012;
    contextOver200k = {
      input = 0.24;
      output = 0.9;
      cacheRead = 0.024;
    };
  };
}
