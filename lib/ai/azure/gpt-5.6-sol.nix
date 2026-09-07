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
}
