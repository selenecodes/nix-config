{mkAiModel}:
mkAiModel {
  name = "eu/gpt-6.1-terra";
  providerModel = "gpt-6.1-terra";
  version = "2026-10-26";
  displayName = "GPT 6.1 Terra";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
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
