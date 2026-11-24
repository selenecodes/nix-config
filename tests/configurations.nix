{
  lib,
  self,
  includeSystemEvaluation ? true,
  evaluationSystem ? null,
}: let
  nixosNames = builtins.attrNames self.nixosConfigurations;
  darwinNames = builtins.attrNames self.darwinConfigurations;
  nativeHosts =
    lib.filterAttrs (_: host:
      evaluationSystem == null || host.pkgs.stdenv.hostPlatform.system == evaluationSystem);
in {
  sharedNixSettings = let
    expectedSubstituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    expectedKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    testsForHost = host: {
      testExperimentalFeatures = {
        expr = let
          features = host.config.nix.settings.experimental-features;
        in
          if builtins.isString features
          then features == "nix-command flakes"
          else lib.all (feature: lib.elem feature features) ["nix-command" "flakes"];
        expected = true;
      };
      testCommonSubstituters = {
        expr = lib.all (substituter: lib.elem substituter host.config.nix.settings.substituters) expectedSubstituters;
        expected = true;
      };
      testCommonKeys = {
        expr = lib.all (key: lib.elem key host.config.nix.settings.trusted-public-keys) expectedKeys;
        expected = true;
      };
      testAllowUnfree = {
        expr = host.config.nixpkgs.config.allowUnfree;
        expected = true;
      };
    };
  in {
    nixos = lib.mapAttrs (_: testsForHost) (nativeHosts self.nixosConfigurations);
    darwin = lib.mapAttrs (_: testsForHost) (nativeHosts self.darwinConfigurations);
    testGaymingKeepsExtraSettings = {
      expr = let
        settings = self.nixosConfigurations.gayming.config.nix.settings;
      in
        settings.auto-optimise-store
        && lib.elem "https://cache.nixos-cuda.org" settings.substituters
        && lib.elem "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" settings.trusted-public-keys;
      expected = true;
    };
  };
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
  (nativeHosts self.nixosConfigurations);
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
  (nativeHosts self.darwinConfigurations);
}
