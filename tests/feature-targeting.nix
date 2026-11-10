{lib}: let
  select = targets: target: let
    evaluation = lib.evalModules {
      modules = [
        ../modules/framework/modules.nix
        {
          options = {
            nixos.configurations = lib.mkOption {type = lib.types.attrs;};
            darwin.configurations = lib.mkOption {type = lib.types.attrs;};
          };
          config = {
            nixos.configurations = {
              gayming = {};
              rwslaptop = {};
            };
            darwin.configurations.studio = {};
            repository.features = [
              {
                nixos = {
                  inherit targets;
                  module = {};
                };
              }
            ];
          };
        }
        ({featureIndex, ...}: {
          options.result = lib.mkOption {type = lib.types.anything;};
          config.result = (featureIndex target).nixos;
        })
      ];
    };
  in
    builtins.length evaluation.config.result;
in {
  testExplicitTargetMatches = {
    expr = select ["gayming"] "gayming";
    expected = 1;
  };
  testExplicitTargetDoesNotLeak = {
    expr = select ["gayming"] "rwslaptop";
    expected = 0;
  };
  testWildcardMatchesGayming = {
    expr = select ["*"] "gayming";
    expected = 1;
  };
  testWildcardMatchesLaptop = {
    expr = select ["*"] "rwslaptop";
    expected = 1;
  };
  testRejectsEmptyTargets = {
    expr = select [] "gayming";
    expectedError = {
      type = "ThrownError";
      msg = "targets must not be empty";
    };
  };
  testRejectsDuplicateTargets = {
    expr = select ["gayming" "gayming"] "gayming";
    expectedError = {
      type = "ThrownError";
      msg = "targets must not contain duplicates";
    };
  };
  testRejectsMixedWildcard = {
    expr = select ["*" "gayming"] "gayming";
    expectedError = {
      type = "ThrownError";
      msg = "targets must not combine";
    };
  };
  testRejectsWrongPlatform = {
    expr = select ["studio"] "gayming";
    expectedError = {
      type = "ThrownError";
      msg = "unknown targets: studio";
    };
  };
  testRejectsUnknownTarget = {
    expr = select ["unknown"] "gayming";
    expectedError = {
      type = "ThrownError";
      msg = "unknown targets: unknown";
    };
  };
}
