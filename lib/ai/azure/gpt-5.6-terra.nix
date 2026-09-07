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
}
