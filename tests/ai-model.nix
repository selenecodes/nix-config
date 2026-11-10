{lib}: let
  ai = import ../lib/ai/lib.nix {inherit lib;};
  model = {
    name = "test-model";
    providerModel = "provider-model";
    displayName = "Test model";
    capabilities = {
      reasoning = false;
      toolCall = false;
    };
    limits = {
      context = 100;
      output = 10;
    };
  };
  reject = input: message: {
    expr = (ai.mkAiModel input).name;
    expectedError = {
      type = "ThrownError";
      msg = message;
    };
  };
  wrongTypes = {
    Integer = 1;
    Float = 1.5;
    Boolean = false;
    List = [];
    Attrs = {};
  };
in {
  requiredStrings = lib.genAttrs ["name" "providerModel" "displayName"] (field: {
    testRejectsMissing = reject (builtins.removeAttrs model [field]) "AI definition requires model[.]${field}";
    testRejectsNull = reject (model // {${field} = null;}) "AI definition requires model[.]${field}";
    testRejectsEmpty = {
      expr = (ai.mkAiModel (model // {${field} = "";})).name;
      expectedError.type = "AssertionError";
    };
    testAcceptsWhitespace = {
      expr = (ai.mkAiModel (model // {${field} = " \t";})).${field};
      expected = " \t";
    };
    wrongTypes = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (model // {${field} = value;}) "model[.]${field} to be a string"
      ))
    wrongTypes;
  });

  containers = lib.genAttrs ["capabilities" "limits"] (field: {
    testRejectsMissing = reject (builtins.removeAttrs model [field]) "requires ${field} to be an attribute set";
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (model // {${field} = value;}) "requires ${field} to be an attribute set"
      )) {
      Null = null;
      String = "invalid";
      List = [];
      Integer = 1;
      Boolean = false;
    };
  });

  capabilities = lib.genAttrs ["reasoning" "toolCall"] (field: {
    testRejectsMissing = reject (model
      // {
        capabilities = builtins.removeAttrs model.capabilities [field];
      }) "model[.]capabilities[.]${field} to be a boolean";
    validValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testAccepts${name}" {
        expr =
          (ai.mkAiModel (model
            // {
              capabilities = model.capabilities // {${field} = value;};
            })).capabilities.${
            field
          };
        expected = value;
      }) {
      True = true;
      False = false;
    };
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (model
          // {
            capabilities = model.capabilities // {${field} = value;};
          }) "model[.]capabilities[.]${field} to be a boolean"
      )) {
      Null = null;
      String = "false";
      Integer = 0;
      List = [];
      Attrs = {};
    };
  });

  limits = lib.genAttrs ["context" "output"] (field: {
    testRejectsMissing = reject (model
      // {
        limits = builtins.removeAttrs model.limits [field];
      }) "model[.]limits[.]${field} to be a positive integer";
    testAcceptsPositiveInteger = {
      expr =
        (ai.mkAiModel (model
          // {
            limits = model.limits // {${field} = 1;};
          })).limits.${
          field
        };
      expected = 1;
    };
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (model
          // {
            limits = model.limits // {${field} = value;};
          }) "model[.]limits[.]${field} to be a positive integer"
      )) {
      Null = null;
      Zero = 0;
      Negative = -1;
      Float = 1.5;
      String = "1";
      Boolean = true;
      List = [];
      Attrs = {};
    };
  });

  reasoningEfforts = {
    validValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testAccepts${name}" {
        expr = (ai.mkAiModel (model // {reasoningEfforts = value;})).reasoningEfforts;
        expected = value;
      }) {
      EmptyList = [];
      Strings = ["low" "high"];
      EmptyString = [""];
    };
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (model // {reasoningEfforts = value;}) "reasoningEfforts must be a list of strings"
      )) {
      Null = null;
      String = "high";
      Attrs = {};
      Integer = 1;
      MixedList = ["high" 1];
      NullElement = [null];
    };
  };

  vllm = {
    validValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testAccepts${name}" {
        expr = (ai.mkAiModel (model // {vllm = value;})).vllm;
        expected = value;
      }) {
      Null = null;
      EmptyArgs = {args = [];};
      StringArgs = {args = ["--quantization" "modelopt"];};
      UntypedArgs = {args = [1 null];};
    };
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (model // {vllm = value;}) "vllm[.]args must be a list"
      )) {
      String = "invalid";
      List = [];
      Integer = 1;
      MissingArgs = {};
      NullArgs = {args = null;};
      StringArgs = {args = "invalid";};
    };
  };

  testDefaultsOptionalFields = {
    expr = let
      result = ai.mkAiModel model;
    in {
      inherit (result) cost reasoningEfforts vllm;
    };
    expected = {
      cost = null;
      reasoningEfforts = null;
      vllm = null;
    };
  };
  testReportsMissingNameBeforeMissingCapabilities = reject (
    builtins.removeAttrs model ["name" "capabilities"]
  ) "requires model[.]name";
  testReportsCapabilitiesBeforeLimits = reject (
    model
    // {
      capabilities = null;
      limits = null;
    }
  ) "requires capabilities to be an attribute set";
  testPreservesSuppliedAndExtraFields = {
    expr = let
      result = ai.mkAiModel (model
        // {
          cost = {
            input = 2;
            output = 3;
          };
          extra = "kept";
        });
    in {
      inherit (result) name providerModel displayName cost extra;
    };
    expected = {
      name = "test-model";
      providerModel = "provider-model";
      displayName = "Test model";
      cost = {
        input = 2;
        output = 3;
      };
      extra = "kept";
    };
  };
}
