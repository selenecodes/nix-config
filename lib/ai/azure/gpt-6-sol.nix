{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6-sol";
  providerModel = "gpt-6-sol";
  version = "2026-09-22";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  cost = {
    input = 2.4;
    output = 12.0;
    cacheRead = 0.24;
    contextOver200k = {
      input = 4.8;
      output = 18.0;
      cacheRead = 0.48;
    };
  };
}
