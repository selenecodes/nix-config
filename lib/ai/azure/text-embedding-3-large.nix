{mkAiModel}:
mkAiModel {
  name = "text-embedding-3-large";
  providerModel = "text-embedding-3-large";
  displayName = "Text Embedding 3 Large";
  capabilities = {
    reasoning = false;
    toolCall = false;
  };
  limits = {
    context = 8191;
    output = 8191;
  };
  cost = {
    input = 0.143;
    output = 0.0;
  };
}
