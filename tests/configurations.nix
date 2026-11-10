{
  lib,
  self,
  includeSystemEvaluation ? true,
}: let
  nixosNames = builtins.attrNames self.nixosConfigurations;
  darwinNames = builtins.attrNames self.darwinConfigurations;
in {
  testHasNixosOutputs = {
    expr = nixosNames != [];
    expected = true;
  };
  testHasDarwinOutputs = {
    expr = darwinNames != [];
    expected = true;
  };
  testOutputNamesAreGloballyUnique = {
    expr = lib.intersectLists nixosNames darwinNames;
    expected = [];
  };
  nixos = lib.mapAttrs (_: host:
    {
      testDockerEnabled = {
        expr = host.config.virtualisation.docker.enable;
        expected = true;
      };
    }
    // lib.optionalAttrs includeSystemEvaluation {
      testSystemEvaluates = {
        expr = builtins.isString host.config.system.build.toplevel.drvPath;
        expected = true;
      };
    })
  self.nixosConfigurations;
  darwin = lib.mapAttrs (_: host:
    {
      testZshEnabled = {
        expr = host.config.programs.zsh.enable;
        expected = true;
      };
    }
    // lib.optionalAttrs includeSystemEvaluation {
      testSystemEvaluates = {
        expr = builtins.isString host.system.drvPath;
        expected = true;
      };
    })
  self.darwinConfigurations;
}
