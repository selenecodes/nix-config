_: {
  nixos.configurations.gayming.module = {pkgs, ...}: {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    environment.systemPackages = [pkgs.solaar];
  };

  darwin.personal = _: {
    homebrew.casks = ["logitech-g-hub"];
  };
}
