_: {
  _module.args.hyprlandCaelestia = {
    nixos = module: {
      nixos = {
        targets = ["gayming" "rwslaptop"];
        inherit module;
      };
    };
    homeManager = module: {
      homeManager = {
        targets = ["gayming" "rwslaptop"];
        inherit module;
      };
    };
  };
}
