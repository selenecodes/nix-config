# NixOS-specific common software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    pciutils
    usbutils
    pinentry-qt  # GPG pinentry (Wayland-friendly)
    signal-desktop
  ];

  # Docker daemon
  virtualisation.docker.enable = true;
}
