_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          programs.thunar.enable = true;

          services = {
            gnome.gnome-keyring.enable = true;
            dbus.enable = true;
            gvfs.enable = true;
            power-profiles-daemon.enable = true;
            tumbler.enable = true;
            udisks2.enable = true;
            upower.enable = true;
          };
        };
      };
    }
  ];
}
