{mkAiModel}:
mkAiModel {
  name = "eu/gpt-5.6-luna";
  providerModel = "gpt-5.6-luna";
  displayName = "GPT 5.6 Luna";
  capabilities = {
    reasoning = true;
    toolCall = true;
  };
  limits = {
    context = 1050000;
    output = 128000;
  };
}
