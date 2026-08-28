_: {
  homeManager.base = {pkgs, ...}: {
    programs.aerospace = {
      enable = pkgs.stdenv.isDarwin;
      launchd.enable = true;
      settings = {
        start-at-login = true;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        gaps = {
          inner = {
            horizontal = 8;
            vertical = 8;
          };
          outer = {
            left = 8;
            bottom = 8;
            top = 8;
            right = 8;
          };
        };

        mode.main.binding = {
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-ctrl-h = "resize width -50";
          alt-ctrl-j = "resize height +50";
          alt-ctrl-k = "resize height -50";
          alt-ctrl-l = "resize width +50";

          alt-f = "fullscreen";
          alt-shift-f = "layout floating tiling";

          alt-comma = "layout accordion horizontal vertical";
          alt-slash = "layout tiles horizontal vertical";

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";

          alt-ctrl-left = "workspace --wrap-around prev";
          alt-ctrl-right = "workspace --wrap-around next";

          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";

          alt-shift-semicolon = "mode service";
        };

        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"];
          backspace = ["close-all-windows-but-current" "mode main"];
        };
      };
    };
  };
}
