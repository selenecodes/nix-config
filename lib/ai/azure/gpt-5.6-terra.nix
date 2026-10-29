{mkAiModel}:
mkAiModel {
  name = "eu/gpt-5.6-terra";
  providerModel = "gpt-5.6-terra";
  displayName = "GPT 5.6 Terra";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
  };
  cost = {
    input = 2.2;
    output = 13.2;
    cacheRead = 0.22;
    contextOver200k = {
      input = 4.4;
      output = 19.8;
      cacheRead = 0.44;
    };
  };
}
