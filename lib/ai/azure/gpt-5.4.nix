{mkAiModel}:
mkAiModel {
  name = "eu/gpt-5.4";
  providerModel = "gpt-5.4";
  displayName = "GPT 5.4";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
  };
  cost = {
    input = 2.75;
    output = 16.5;
    cacheRead = 0.28;
    contextOver200k = {
      input = 5.0;
      output = 22.5;
      cacheRead = 0.5;
    };
  };
}
