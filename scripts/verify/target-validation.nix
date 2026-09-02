{lib}: let
  root = ../..;
  select = targets: target: let
    evaluation = lib.evalModules {
      modules = [
        (root + "/modules/framework/modules.nix")
        ({lib, ...}: {
          options = {
            nixos.configurations = lib.mkOption {type = lib.types.attrs;};
            darwin.configurations = lib.mkOption {type = lib.types.attrs;};
          };
          config = {
            nixos.configurations.gayming = {};
            nixos.configurations.rwslaptop = {};
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
        })
        ({
          featureIndex,
          lib,
          ...
        }: {
          options.result = lib.mkOption {type = lib.types.anything;};
          config.result = (featureIndex target).nixos;
        })
      ];
    };
  in
    builtins.length evaluation.config.result;
  rejects = targets: !(builtins.tryEval (select targets "gayming")).success;
in
  assert select ["gayming"] "gayming" == 1;
  assert select ["gayming"] "rwslaptop" == 0;
  assert select ["*"] "gayming" == 1;
  assert select ["*"] "rwslaptop" == 1;
  assert rejects [];
  assert rejects ["gayming" "gayming"];
  assert rejects ["*" "gayming"];
  assert rejects ["studio"];
  assert rejects ["unknown"]; true
