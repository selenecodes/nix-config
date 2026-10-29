{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6.1-sol";
  providerModel = "gpt-6.1-sol";
  version = "2026-09-29";
  displayName = "GPT 6.1 Sol";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
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
