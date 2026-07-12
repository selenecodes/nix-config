_: {
  nixos.desktop = _: {
    services = {
      gnome.gnome-keyring.enable = true;
      dbus.enable = true;
      gvfs.enable = true;
    };
    # Unlocks gnome-keyring at greetd login
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
