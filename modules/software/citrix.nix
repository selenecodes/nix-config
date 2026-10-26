_: {
  repository.features = [
    {
      nixos = {
        targets = ["rwslaptop"];
        module = {
          config,
          lib,
          pkgsStable,
          ...
        }: let
          citrixWorkspace = pkgsStable.citrix_workspace.overrideAttrs {
            version = "26.04.10.1";
            src = pkgsStable.requireFile {
              name = "linuxx64-gcc-8-26.04.10.1.tar.gz";
              sha256 = "sha256-jAoiytSkzagCy107sJuJd50g9oul5FS4ZIU1TFVzVrU=";
              message = "Download the Citrix Workspace GCC 8 archive and add it with nix-prefetch-url file://$PWD/linuxx64-gcc-8-26.04.10.1.tar.gz.";
            };
          };
        in {
          options.myConfig.citrix.enable = lib.mkEnableOption "Citrix Workspace";

          config = lib.mkIf config.myConfig.citrix.enable {
            # The GCC 8 release depends on EOL libsoup 2.
            nixpkgs.config.permittedInsecurePackages = ["libsoup-2.74.3"];
            environment.systemPackages = [citrixWorkspace];
          };
        };
      };

      homeManager = {
        targets = ["rwslaptop"];
        module = {
          xdg.mimeApps = {
            enable = true;
            defaultApplications."application/x-ica" = ["wfica.desktop"];
          };

          # Citrix Workspace 26.04 crashes in NVIDIA's native Wayland EGL path.
          xdg.desktopEntries.wfica = {
            name = "Citrix Workspace Engine";
            exec = "env -u WAYLAND_DISPLAY EGL_PLATFORM=x11 adapter %f";
            type = "Application";
            noDisplay = true;
            mimeType = ["application/x-ica"];
          };
        };
      };

      darwin = {
        targets = ["studio"];
        module.homebrew.casks = ["citrix-workspace"];
      };
    }
  ];
}
