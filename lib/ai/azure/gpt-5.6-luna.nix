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
  cost = {
    input = 0.22;
    output = 1.32;
    cacheRead = 0.022;
    contextOver200k = {
      input = 0.44;
      output = 1.98;
      cacheRead = 0.044;
    };
  };
}
