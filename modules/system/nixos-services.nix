{ lib, pkgs, config, ... }:
lib.mkIf config.myconfig.isGaming {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."10-clock-rate" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 128;
        "default.clock.max-quantum" = 1024;
      };
    };
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  networking.nameservers = [
    "1.1.1.1" "1.0.0.1"
    "2606:4700:4700::1111" "2606:4700:4700::1001"
  ];

  services.tailscale.enable = true;
  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Unlocks gnome-keyring at greetd login
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.dbus.enable = true;
  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    config.niri.default = [ "gnome" "gtk" ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
