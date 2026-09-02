_: {
  nixos.base = {pkgs, ...}: {
    environment.systemPackages = [pkgs.usbutils];
  };
}
