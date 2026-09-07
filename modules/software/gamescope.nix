_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming"];
        module.programs.gamescope = {
          enable = true;
          capSysNice = true;
        };
      };
    }
  ];
}
