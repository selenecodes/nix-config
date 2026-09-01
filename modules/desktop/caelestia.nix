{
  inputs,
  lib,
  ...
}: {
  nixos.desktop = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  homeManager.caelestia = {
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
    imports = [inputs.caelestia-shell.homeManagerModules.default];

    options.myConfig.caelestia.extraHyprlandConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Host-specific Lua appended to Caelestia's Hyprland configuration";
    };

    config = {
      programs.caelestia = {
        enable = true;
        package = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs (old: {
          patches = (old.patches or []) ++ [./caelestia-network-both.patch];
        });
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
        settings = {
          general = {
            apps = {
              terminal = ["ghostty" "-e"];
              audio = ["pavucontrol"];
              explorer = ["thunar"];
            };
            idle = {
              lockBeforeSleep = true;
              inhibitWhenAudio = true;
              inhibitWhenCharging = false;
              timeouts = [
                {
                  timeout = 180;
                  idleAction = "lock";
                  inhibitWhenAudio = false;
                  inhibitWhenCharging = false;
                  respectInhibitors = true;
                }
                {
                  timeout = 300;
                  idleAction = "dpms off";
                  returnAction = "dpms on";
                }
                {
                  timeout = 600;
                  idleAction = ["systemctl" "suspend"];
                }
              ];
            };
          };
          bar = {
            persistent = true;
            showOnHover = false;
          };
          lock = {
            enableFprint = false;
            enableHowdy = false;
            triggerHowdyOnWake = false;
          };
          paths.wallpaperDir = "~/Pictures/Wallpapers";
          services.useFahrenheit = false;
          session.commands = {
            logout = ["uwsm" "stop"];
            shutdown = ["systemctl" "poweroff"];
            hibernate = ["systemctl" "suspend"];
            reboot = ["systemctl" "reboot"];
          };
          session.icons.hibernate = "bedtime";
        };
        cli = {
          enable = true;
          settings = {
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
            toggles = {
              communication = {
                discord.enable = false;
                whatsapp.enable = false;
                signal = {
                  enable = true;
                  match = [{class = "signal";}];
                  command = ["signal-desktop"];
                  move = true;
                };
              };
              music = {
                spotify.enable = false;
                feishin.enable = false;
              };
              sysmon.btop = {
                enable = true;
                match = [
                  {
                    class = "com.github.aristocratos.btop";
                    title = "btop";
                    workspace.name = "special:sysmon";
                  }
                ];
                command = ["ghostty" "--class=com.github.aristocratos.btop" "-e" "btop"];
              };
              todo.todoist.enable = false;
            };
          };
        };
      };

      programs = {
        btop = {
          enable = true;
          settings = {
            color_theme = "caelestia";
            theme_background = false;
          };
        };
        direnv = {
          enable = true;
          enableZshIntegration = true;
        };
      };

      services.polkit-gnome.enable = true;

      home = {
        packages = with pkgs; [
          adw-gtk3
          bluez
          cava
          darkly
          ddcutil
          eza
          fastfetch
          hyprpicker
          papirus-icon-theme
          pavucontrol
          qtengine
          trash-cli
        ];
        pointerCursor = {
          enable = true;
          package = sweetCursor;
          name = "Sweet-cursors";
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };
        file."Pictures/Wallpapers/kaguya-iroha-yachiyo.png".source = ../assets/wallpapers/kaguya-iroha-yachiyo.png;
      };

      gtk.enable = true;

      xdg = {
        configFile = {
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

            -- Keep the workspace edge gap consistent whether it has one window or many.
            hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 8 })
            hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 8 })

            hl.bind("SUPER + SHIFT + Space", hl.dsp.exec_cmd("1password --quick-access"))

            for i = 1, 10 do
              local key = i % 10
              hl.bind("SUPER + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
              hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
            end

            ${config.myConfig.caelestia.extraHyprlandConfig}
          '';
          "fastfetch/config.jsonc".source = "${caelestiaDots}/fastfetch/config.jsonc";
        };
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

      systemd.user = {
        services = {
          caelestia-1password = {
            Unit = {
              Description = "Start 1Password in the desktop session";
              PartOf = ["graphical-session.target"];
              After = ["graphical-session.target"];
            };
            Service = {
              ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
              Restart = "on-failure";
            };
            Install.WantedBy = ["graphical-session.target"];
          };
          caelestia-initialize = {
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
        };
      };
    };
  };
}
