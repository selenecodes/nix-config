# NixOS-specific common software
{ pkgs, ... }: {
  # Udev rules to recognize the YubiKey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.systemPackages = with pkgs; [
    wget
    curl
    pciutils
    usbutils
    pinentry-qt  # GPG pinentry (Wayland-friendly)
    signal-desktop
    # Yubikey
    yubikey-manager         # ykman CLI
    yubioath-flutter        # Authenticator GUI
    yubikey-touch-detector  # Notifies you when a touch is needed
  ];

  # Docker daemon
  virtualisation.docker.enable = true;
}
