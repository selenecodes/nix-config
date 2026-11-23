{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6.1-sol";
  providerModel = "gpt-6.1-sol";
  version = "2026-09-29";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  cost = {
    input = 2.4;
    output = 12.0;
    cacheRead = 0.12;
    contextOver200k = {
      input = 4.8;
      output = 18.0;
      cacheRead = 0.24;
    };
  };
}
