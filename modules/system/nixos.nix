_: {
  nixos.base = {pkgs, ...}: {
    services.udev.packages = [pkgs.yubikey-personalization];

    environment.systemPackages = with pkgs; [
      wget
      curl
      pciutils
      usbutils
      pinentry-qt
      signal-desktop
      yubikey-manager
      yubioath-flutter
      yubikey-touch-detector
    ];

    virtualisation.docker.enable = true;
  };
}
