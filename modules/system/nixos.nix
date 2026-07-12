_: {
  nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      wget
      curl
      htop
      pinentry-qt
      signal-desktop
    ];

    virtualisation.docker.enable = true;
  };
}
