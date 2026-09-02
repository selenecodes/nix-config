{
  hyprlandCaelestia,
  inputs,
  ...
}: {
  repository.features = [
    (hyprlandCaelestia.nixos ({pkgs, ...}: {
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];
    }))
    (hyprlandCaelestia.homeManager (
      {
        config,
        pkgs,
        ...
      }: {
        imports = [inputs.caelestia-shell.homeManagerModules.default];

        programs.caelestia = {
          enable = true;
          package = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs (old: {
            patches = (old.patches or []) ++ [./files/caelestia-network-both.patch];
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
            settings.toggles = {
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

        services.polkit-gnome.enable = true;

        home.packages = with pkgs; [
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

        systemd.user.services.caelestia-1password = {
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
      }
    ))
  ];
}
