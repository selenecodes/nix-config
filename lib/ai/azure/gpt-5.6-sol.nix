{mkAiModel}:
mkAiModel {
  name = "eu/gpt-5.6-sol";
  providerModel = "gpt-5.6-sol";
  displayName = "GPT 5.6 Sol";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
  };
  cost = {
    input = 4.4;
    output = 22.0;
    cacheRead = 0.44;
    contextOver200k = {
      input = 8.8;
      output = 33.0;
      cacheRead = 0.88;
    };
  };
}
