_: let
  targets = ["gayming" "rwslaptop"];
in {
  _module.args.hyprlandCaelestia = {
    nixos = module: {
      nixos = {
        inherit targets;
        inherit module;
      };
    };
    homeManager = module: {
      homeManager = {
        inherit targets;
        inherit module;
      };
    };
  };
}
