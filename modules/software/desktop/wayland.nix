_: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {
          environment.sessionVariables = {
            NIXOS_OZONE_WL = "1";
            MOZ_ENABLE_WAYLAND = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            XDG_SESSION_TYPE = "wayland";
          };

          services.xserver.xkb.layout = "us";
        };
      };
      homeManager = {
        targets = ["gayming" "rwslaptop"];
        module = {pkgs, ...}: {
          home.packages = with pkgs; [
            wl-clipboard
            cliphist
            grim
            slurp
          ];

          home.sessionVariables = {
            EDITOR = "nvim";
            NIXOS_OZONE_WL = "1";
          };

          xdg.enable = true;
          # Caelestia provides the NetworkManager controls in its status area.
          services.network-manager-applet.enable = false;
        };
      };
    }
  ];
}
