_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module.hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
      };
    }
  ];
}
