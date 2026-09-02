{
  config,
  lib,
  ...
}: let
  facet = lib.types.submodule {
    options = {
      targets = lib.mkOption {type = lib.types.listOf lib.types.str;};
      module = lib.mkOption {type = lib.types.deferredModule;};
    };
  };
  feature = lib.types.submodule {
    options = {
      nixos = lib.mkOption {
        type = lib.types.nullOr facet;
        default = null;
      };
      darwin = lib.mkOption {
        type = lib.types.nullOr facet;
        default = null;
      };
      homeManager = lib.mkOption {
        type = lib.types.nullOr facet;
        default = null;
      };
    };
  };
  modulesFor = facetName: target:
    lib.concatMap (
      record: let
        facetRecord = record.${facetName};
      in
        lib.optional (
          facetRecord
          != null
          && (lib.elem "*" facetRecord.targets || lib.elem target facetRecord.targets)
        )
        facetRecord.module
    )
    config.repository.features;
in {
  options.repository.features = lib.mkOption {
    type = lib.types.listOf feature;
    default = [];
    internal = true;
  };

  config._module.args.featureIndex = target: {
    nixos = modulesFor "nixos" target;
    darwin = modulesFor "darwin" target;
    homeManager = modulesFor "homeManager" target;
  };
}
