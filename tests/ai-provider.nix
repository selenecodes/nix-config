{lib}: let
  ai = import ../lib/ai/lib.nix {inherit lib;};
  provider = {
    name = "test-provider";
    models = ["first" "second"];
    bifrost = {keys = [];};
  };
  reject = input: message: {
    expr = (ai.mkAiProvider input).name;
    expectedError = {
      type = "ThrownError";
      msg = message;
    };
  };
in {
  name = {
    testRejectsMissing = reject (builtins.removeAttrs provider ["name"]) "requires provider[.]name";
    testRejectsNull = reject (provider // {name = null;}) "requires provider[.]name";
    testRejectsEmpty = {
      expr = (ai.mkAiProvider (provider // {name = "";})).name;
      expectedError.type = "AssertionError";
    };
    testAcceptsWhitespace = {
      expr = (ai.mkAiProvider (provider // {name = " \t";})).name;
      expected = " \t";
    };
    wrongTypes = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (provider // {name = value;}) "provider[.]name to be a string"
      )) {
      Integer = 1;
      Float = 1.5;
      Boolean = false;
      List = [];
      Attrs = {};
    };
  };

  models = {
    testRejectsMissing = reject (builtins.removeAttrs provider ["models"]) "AI provider test-provider requires models";
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (provider // {models = value;}) "AI provider test-provider requires models"
      )) {
      Null = null;
      EmptyList = [];
      String = "model";
      Integer = 1;
      Boolean = true;
      Attrs = {};
    };
    testPreservesModelList = {
      expr = (ai.mkAiProvider provider).models;
      expected = ["first" "second"];
    };
    testDoesNotConstrainModelElementTypes = {
      expr = (ai.mkAiProvider (provider // {models = [1];})).models;
      expected = [1];
    };
  };

  bifrost = {
    testRejectsMissing = reject (builtins.removeAttrs provider ["bifrost"]) "provider[.]bifrost to be an attribute set";
    testRejectsEmpty = {
      expr = (ai.mkAiProvider (provider // {bifrost = {};})).name;
      expectedError.type = "AssertionError";
    };
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (provider // {bifrost = value;}) "provider[.]bifrost to be an attribute set"
      )) {
      Null = null;
      String = "invalid";
      List = [];
      Integer = 1;
      Boolean = false;
    };
    testPreservesSettings = {
      expr = (ai.mkAiProvider provider).bifrost;
      expected = {keys = [];};
    };
  };

  local = {
    testDefaultsToRemote = {
      expr = (ai.mkAiProvider provider).local;
      expected = false;
    };
    testAcceptsFalse = {
      expr = (ai.mkAiProvider (provider // {local = false;})).local;
      expected = false;
    };
    invalidValues = lib.mapAttrs' (name: value:
      lib.nameValuePair "testRejects${name}" (
        reject (provider // {local = value;}) "provider[.]local to be a boolean"
      )) {
      Null = null;
      String = "false";
      Integer = 0;
      List = [];
      Attrs = {};
    };
  };

  activeModel = {
    testDefaultsToNullForRemote = {
      expr = (ai.mkAiProvider provider).activeModel;
      expected = null;
    };
    testRemoteMaySpecifyUnregisteredModel = {
      expr = (ai.mkAiProvider (provider // {activeModel = "other";})).activeModel;
      expected = "other";
    };
    testRejectsMissingForLocal = reject (provider // {local = true;}) "Local AI provider test-provider requires activeModel";
    testRejectsNullForLocal = reject (provider
      // {
        local = true;
        activeModel = null;
      }) "Local AI provider test-provider requires activeModel";
    testRejectsUnregisteredForLocal = reject (provider
      // {
        local = true;
        activeModel = "other";
      }) "activeModel must be registered";
    testAcceptsRegisteredLocalModel = {
      expr = let
        result = ai.mkAiProvider (provider
          // {
            local = true;
            activeModel = "second";
          });
      in {
        inherit (result) local activeModel;
      };
      expected = {
        local = true;
        activeModel = "second";
      };
    };
  };

  testPreservesExtraFields = {
    expr = (ai.mkAiProvider (provider // {extra = "kept";})).extra;
    expected = "kept";
  };
  testReportsModelsBeforeBifrost = reject (
    provider
    // {
      models = [];
      bifrost = null;
    }
  ) "AI provider test-provider requires models";
}
