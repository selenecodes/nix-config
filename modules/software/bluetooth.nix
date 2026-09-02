_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming" "rwslaptop"];
        module.hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
      };
    }
  ];
}
