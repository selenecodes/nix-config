{
  lib,
  self,
  includeSystemEvaluation ? true,
}: {
  aiCatalog = import ./ai-catalog.nix {inherit lib;};
  aiModel = import ./ai-model.nix {inherit lib;};
  aiProvider = import ./ai-provider.nix {inherit lib;};
  featureTargeting = import ./feature-targeting.nix {inherit lib;};
  configurations = import ./configurations.nix {inherit lib self includeSystemEvaluation;};
  displaylink = import ./displaylink.nix {inherit self;};
  structure = import ./structure.nix {inherit lib;};
}
