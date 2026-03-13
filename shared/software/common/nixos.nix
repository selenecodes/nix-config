# NixOS-specific common software
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    pciutils
    usbutils
    pinentry-qt  # GPG pinentry (Wayland-friendly)
    signal-desktop
    netbird       # VPN (cross-platform)
  ];

  # Docker daemon
  virtualisation.docker.enable = true;

  # 1Password SSH agent + polkit integration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "selene" ];
  };
}
