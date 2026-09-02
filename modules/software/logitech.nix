_: {
  nixos.configurations.gayming.module = _: {
    hardware.logitech.wireless = {
      enable = true;
    };
    programs.solaar.enable = true;
  };

  darwin.personal = _: {
    homebrew.casks = [
      "openlogi"
      # "logitech-g-hub"
    ];
  };
}
