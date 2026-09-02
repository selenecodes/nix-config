_: {
  _module.args.common.system = module: {
    nixos = {
      targets = ["*"];
      inherit module;
    };
    darwin = {
      targets = ["*"];
      inherit module;
    };
  };
}
