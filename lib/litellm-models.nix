{
  upstreamBaseUrl,
  lib,
}: let
  costPerToken = cost:
    lib.mapAttrs (
      key: value:
        if key == "context_over_200k"
        then costPerToken value
        else value / 1000000.0
    )
    cost;
  toLiteLLMModelInfo = cost: let
    perToken = costPerToken cost;
  in
    {
      input_cost_per_token = perToken.input;
      output_cost_per_token = perToken.output;
    }
    // lib.optionalAttrs (perToken ? cache_read) {
      cache_read_input_token_cost = perToken.cache_read;
    }
    // lib.optionalAttrs (perToken ? context_over_200k) {
      input_cost_per_token_above_272k_tokens = perToken.context_over_200k.input;
      output_cost_per_token_above_272k_tokens = perToken.context_over_200k.output;
    }
    // lib.optionalAttrs (perToken.context_over_200k or {} ? cache_read) {
      cache_read_input_token_cost_above_272k_tokens = perToken.context_over_200k.cache_read;
    };
  toYaml = value:
    if builtins.isString value
    then value
    else builtins.toJSON value;
  renderModelInfo = modelInfo:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (key: value: "          ${key}: ${toYaml value}") modelInfo
    );
  renderModel = id: model:
    ''
      - model_name: ${id}
        litellm_params:
          model: azure/${id}
          api_base: ${upstreamBaseUrl}
    ''
    + lib.optionalString (model ? cost) ''
        model_info:
      ${renderModelInfo (toLiteLLMModelInfo model.cost)}
    '';
in rec {
  models = {
    "gpt-5.1" = {
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
    "gpt-5.4" = {
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
    "gpt-5.5" = {
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
    "gpt-5.6-luna" = {
      name = "GPT 5.6 Luna";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
    };
    "gpt-5.6-sol" = {
      name = "GPT 5.6 Sol";
      reasoning = true;
      tool_call = true;
      limit = {
        context = 1050000;
        output = 128000;
      };
    };
    "gpt-5.6-terra" = {
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

  opencodeModels = lib.filterAttrs (_: model: model.tool_call or false) models;
  litellmModelList = lib.concatStringsSep "" (lib.mapAttrsToList renderModel models);
}
