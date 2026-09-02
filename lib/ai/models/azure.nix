{
  bifrost = {
    keys = [
      {
        name = "azure-default-credential";
        value = "";
        models = ["eu/gpt-5.1" "eu/gpt-5.4" "eu/gpt-5.5" "eu/gpt-5.6-luna" "eu/gpt-5.6-sol" "eu/gpt-5.6-terra" "text-embedding-3-large"];
        weight = 1.0;
        aliases = {
          "eu/gpt-5.1" = "gpt-5.1";
          "eu/gpt-5.4" = "gpt-5.4";
          "eu/gpt-5.5" = "gpt-5.5";
          "eu/gpt-5.6-luna" = "gpt-5.6-luna";
          "eu/gpt-5.6-sol" = "gpt-5.6-sol";
          "eu/gpt-5.6-terra" = "gpt-5.6-terra";
          "text-embedding-3-large" = "text-embedding-3-large";
        };
        azure_key_config.endpoint = "https://apim.datalab-01.azure.grid.rws.nl/";
      }
    ];
  };

  opencode.models = {
    "eu/gpt-5.1" = {
      name = "GPT 5.1";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 272000;
        output = 128000;
      };
      cost = {
        input = 1.38;
        output = 11.0;
        cache_read = 0.14;
      };
    };
    "eu/gpt-5.4" = {
      name = "GPT 5.4";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
      cost = {
        input = 2.75;
        output = 16.5;
        cache_read = 0.28;
        context_over_200k = {
          input = 5.0;
          output = 22.5;
          cache_read = 0.5;
        };
      };
    };
    "eu/gpt-5.5" = {
      name = "GPT 5.5";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
      cost = {
        input = 5.5;
        output = 33.0;
        cache_read = 0.55;
        context_over_200k = {
          input = 11.0;
          output = 49.5;
          cache_read = 1.1;
        };
      };
    };
    "eu/gpt-5.6-luna" = {
      name = "GPT 5.6 Luna";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
    };
    "eu/gpt-5.6-sol" = {
      name = "GPT 5.6 Sol";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
    };
    "eu/gpt-5.6-terra" = {
      name = "GPT 5.6 Terra";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
    };
    "text-embedding-3-large" = {
      name = "Text Embedding 3 Large";
      limit = {
        context = 8191;
        output = 8191;
      };
      cost = {
        input = 0.143;
        output = 0.0;
      };
    };
  };

  codex = {
    model = "eu/gpt-5.6-luna";
    model_provider = "bifrost";
    model_reasoning_effort = "medium";
    model_providers.bifrost = {
      name = "Bifrost (proxy)";
      base_url = "http://127.0.0.1:4000/v1";
      wire_api = "responses";
      model_reasoning_effort = "medium";
    };
  };
}
