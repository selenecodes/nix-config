{mkAiModel}:
mkAiModel {
  name = "eu/gpt-5.5";
  providerModel = "gpt-5.5";
  displayName = "GPT 5.5";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
  };
  cost = {
    input = 5.5;
    output = 33.0;
    cacheRead = 0.55;
    contextOver200k = {
      input = 11.0;
      output = 49.5;
      cacheRead = 1.1;
    };
  };
}
