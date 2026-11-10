{
  lib,
  self,
  includeSystemEvaluation ? true,
  evaluationSystem ? null,
}:
{
  aiCatalog = import ./ai-catalog.nix {inherit lib;};
  aiModel = import ./ai-model.nix {inherit lib;};
  aiProvider = import ./ai-provider.nix {inherit lib;};
  featureTargeting = import ./feature-targeting.nix {inherit lib;};
  configurations = import ./configurations.nix {inherit lib self includeSystemEvaluation evaluationSystem;};
  structure = import ./structure.nix {inherit lib;};
}
// lib.optionalAttrs (evaluationSystem == null || self.nixosConfigurations.rwslaptop.pkgs.stdenv.hostPlatform.system == evaluationSystem) {
  displaylink = import ./displaylink.nix {inherit self;};
}
