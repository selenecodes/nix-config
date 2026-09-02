_: {
  nixos.base = {pkgs, ...}: {
    services.udev.packages = [pkgs.yubikey-personalization];

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubioath-flutter
      yubikey-touch-detector
    ];
  };
}
