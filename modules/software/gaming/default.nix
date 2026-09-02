_: {
  _module.args.gaming.nixos = module: {
    nixos = {
      targets = ["gayming"];
      inherit module;
    };
  };
}
