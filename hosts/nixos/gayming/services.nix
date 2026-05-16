{ lib, pkgs, ... }:

{
  # PipeWire audio with low-latency config
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

  # Ananicy-cpp with CachyOS rules for process prioritisation
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Networking
  networking.nameservers = [
    "1.1.1.1" "1.0.0.1"
    "2606:4700:4700::1111" "2606:4700:4700::1001"
  ];

  # Tailscale VPN
  services.tailscale.enable = true;

  # Bluetooth manager
  services.blueman.enable = true;

  # GNOME keyring (for secrets / credentials)
  services.gnome.gnome-keyring.enable = true;

  # Wire gnome-keyring into greetd's PAM stack so the daemon starts and the
  # keyring is auto-unlocked at login. Without this greetd logs:
  #   "gkr-pam: unable to locate daemon control file"
  # https://search.nixos.org/options?query=enableGnomeKeyring
  security.pam.services.greetd.enableGnomeKeyring = true;

  # SSH server (key-only)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # D-Bus
  services.dbus.enable = true;

  # GVFS for trash support in file managers
  services.gvfs.enable = true;

  # XDG portals — gnome for ScreenCast/Screenshot (window picker in Chrome etc.), gtk for the rest
  xdg.portal = {
    enable = true;
    config.niri.default = [ "gnome" "gtk" ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
