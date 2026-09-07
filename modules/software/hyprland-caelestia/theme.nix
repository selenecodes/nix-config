{
  hyprlandCaelestia,
  inputs,
  lib,
  ...
}: {
  repository.features = [
    (hyprlandCaelestia.homeManager (
      {
        config,
        pkgs,
        ...
      }: let
        caelestiaDots = inputs.caelestia-dots;
        sweetCursor = pkgs.runCommand "sweet-cursors" {} ''
          mkdir -p "$out/share/icons"
          cp -r ${inputs.sweet-theme}/kde/cursors/Sweet-cursors "$out/share/icons/"
        '';
        wallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/kaguya-iroha-yachiyo.png";
        caelestia = "${config.programs.caelestia.cli.package}/bin/caelestia";
        initializeScheme = pkgs.writeShellScript "initialize-caelestia-scheme" ''
          set -eu

          for _ in $(${pkgs.coreutils}/bin/seq 1 30); do
            if ${caelestia} shell -s >/dev/null 2>&1; then
              break
            fi
            ${pkgs.coreutils}/bin/sleep 1
          done

          ${caelestia} shell -s >/dev/null
          if [ ! -e "$HOME/.local/state/caelestia/wallpaper" ]; then
            ${caelestia} wallpaper -f ${lib.escapeShellArg wallpaper}
          fi
          ${caelestia} scheme set -n dynamic
        '';
      in {
        programs.caelestia.cli.settings = {
          wallpaper.postHook = "caelestia scheme set -n dynamic";
          theme = {
            enableTerm = true;
            enableHypr = true;
            enableDiscord = false;
            enableSpicetify = false;
            enablePandora = false;
            enableFuzzel = true;
            enableBtop = true;
            enableNvtop = false;
            enableHtop = false;
            enableGtk = true;
            enableQt = true;
            enableWarp = false;
            enableChromium = false;
            enableZed = false;
            enableCava = true;
            iconTheme = "Papirus-Dark";
            iconThemeLight = "Papirus-Light";
            iconThemeDark = "Papirus-Dark";
          };
        };

        programs.btop = {
          enable = true;
          settings = {
            color_theme = "caelestia";
            theme_background = false;
          };
        };

        home = {
          pointerCursor = {
            enable = true;
            package = sweetCursor;
            name = "Sweet-cursors";
            size = 24;
            gtk.enable = true;
            x11.enable = true;
          };
          file."Pictures/Wallpapers/kaguya-iroha-yachiyo.png".source = ../../../assets/wallpapers/kaguya-iroha-yachiyo.png;
        };

        gtk.enable = true;

        xdg.configFile = {
          "hypr/hyprland.lua".source = "${caelestiaDots}/hypr/hyprland.lua";
          "hypr/variables.lua".source = "${caelestiaDots}/hypr/variables.lua";
          "hypr/hyprland" = {
            source = "${caelestiaDots}/hypr/hyprland";
            recursive = true;
          };
          "hypr/utils" = {
            source = "${caelestiaDots}/hypr/utils";
            recursive = true;
          };
          "hypr/scheme/default.lua".source = "${caelestiaDots}/hypr/scheme/default.lua";
          "caelestia/hypr-vars.lua".text = ''
            return {
              terminal = "ghostty",
              browser = "google-chrome-stable",
              editor = "code",
              fileExplorer = "thunar",
              audioSettings = "pavucontrol",
              cursorTheme = "Sweet-cursors",
              sleepGestureCmd = "systemctl suspend",
              kbClipboardPasteLatest = "",
              kbMusicWs = "",
              kbTodoWs = "",
              singleWindowGapsOut = 8,
            }
          '';
          "caelestia/hypr-user.lua".text = ''
            hl.config({
              ecosystem = {
                no_update_news = true,
                no_donation_nag = true,
              },
            })

            hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 8 })
            hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 8 })

            hl.bind("SUPER + SHIFT + Space", hl.dsp.exec_cmd("1password --quick-access"))

            for i = 1, 10 do
              local key = i % 10
              hl.bind("SUPER + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
              hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
            end
          '';
          "fastfetch/config.jsonc".source = "${caelestiaDots}/fastfetch/config.jsonc";
        };

        systemd.user.services.caelestia-initialize = {
          Unit = {
            Description = "Initialize the Caelestia dynamic wallpaper scheme";
            PartOf = ["graphical-session.target"];
            After = ["graphical-session.target"];
          };
          Service = {
            Type = "oneshot";
            ExecStart = initializeScheme;
          };
          Install.WantedBy = ["graphical-session.target"];
        };
      }
    ))
  ];
}
