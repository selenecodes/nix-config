_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module.hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        module.services.blueman.enable = true;
      };
    }
  ];
}
