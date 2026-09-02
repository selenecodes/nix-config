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
      homeManager = {
        targets = ["gayming" "rwslaptop"];
        module = {config, ...}: {
          xdg = {
            userDirs = {
              enable = true;
              createDirectories = true;
              desktop = "${config.home.homeDirectory}/Desktop";
              documents = "${config.home.homeDirectory}/Documents";
              download = "${config.home.homeDirectory}/Downloads";
              music = "${config.home.homeDirectory}/Music";
              pictures = "${config.home.homeDirectory}/Pictures";
              publicShare = "${config.home.homeDirectory}/Public";
              templates = "${config.home.homeDirectory}/Templates";
              videos = "${config.home.homeDirectory}/Videos";
            };
            mimeApps = {
              enable = true;
              defaultApplications = {
                "text/html" = ["google-chrome.desktop"];
                "x-scheme-handler/http" = ["google-chrome.desktop"];
                "x-scheme-handler/https" = ["google-chrome.desktop"];
                "inode/directory" = ["thunar.desktop"];
              };
            };
          };
        };
      };
    }
  ];
}
