_: {
  _module.args.work.system = module: {
    nixos = {
      targets = ["rwslaptop"];
      inherit module;
    };
    darwin = {
      targets = ["studio"];
      inherit module;
    };
  };
}
