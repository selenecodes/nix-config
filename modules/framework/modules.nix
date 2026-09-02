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
  targetsByFacet = {
    nixos = builtins.attrNames config.nixos.configurations;
    darwin = builtins.attrNames config.darwin.configurations;
    homeManager = lib.unique (targetsByFacet.nixos ++ targetsByFacet.darwin);
  };
  validateTargets = facetName: targets: let
    explicitTargets = lib.remove "*" targets;
    unknownTargets = lib.subtractLists targetsByFacet.${facetName} explicitTargets;
  in
    assert lib.assertMsg (targets != []) "repository feature ${facetName} targets must not be empty";
    assert lib.assertMsg (lib.length targets == lib.length (lib.unique targets)) "repository feature ${facetName} targets must not contain duplicates";
    assert lib.assertMsg (!(lib.elem "*" targets && explicitTargets != [])) "repository feature ${facetName} targets must not combine * with explicit targets";
    assert lib.assertMsg (unknownTargets == []) "repository feature ${facetName} has unknown targets: ${lib.concatStringsSep ", " unknownTargets}"; targets;
  modulesFor = facetName: target:
    lib.concatMap (
      record: let
        facetRecord = record.${facetName};
        targets =
          if facetRecord == null
          then []
          else validateTargets facetName facetRecord.targets;
      in
        lib.optional (
          facetRecord
          != null
          && (lib.elem "*" targets || lib.elem target targets)
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
