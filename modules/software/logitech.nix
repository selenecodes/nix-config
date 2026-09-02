_: {
  repository.features = [
    {
      nixos = {
        targets = ["gayming"];
        module = {
          hardware.logitech.wireless.enable = true;
          programs.solaar.enable = true;
        };
      };
      darwin = {
        targets = ["studio"];
        module.homebrew.casks = [
          "openlogi"
          # "logitech-g-hub"
        ];
      };
    }
  ];
}
