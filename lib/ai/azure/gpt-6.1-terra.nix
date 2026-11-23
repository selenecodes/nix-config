{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6.1-terra";
  providerModel = "gpt-6.1-terra";
  version = "2026-10-26";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  cost = {
    input = 1.2;
    output = 6.0;
    cacheRead = 0.06;
    contextOver200k = {
      input = 2.4;
      output = 9.0;
      cacheRead = 0.12;
    };
  };
}
