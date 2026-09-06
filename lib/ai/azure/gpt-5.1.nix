{mkAiModel}:
mkAiModel {
  name = "eu/gpt-5.1";
  providerModel = "gpt-5.1";
  displayName = "GPT 5.1";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 272000;
    output = 128000;
  };
  cost = {
    input = 1.38;
    output = 11.0;
    cacheRead = 0.14;
  };
}
