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
      {pkgs, ...}: let
        system = pkgs.stdenv.hostPlatform.system;
        shellPkgs = inputs.caelestia-shell.packages.${system};

        # Workaround: the fetched source has no .git, so setuptools-scm
        # can't detect a version. Remove once fixed upstream.
        patchedCli =
          inputs.caelestia-shell.inputs.caelestia-cli.packages.${system}.default.overridePythonAttrs
          (old: {
            preBuild =
              (old.preBuild or "")
              + ''
                export SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0+g6b84ee5
              '';
          });
      in {
        imports = [inputs.caelestia-shell.homeManagerModules.default];

        programs.caelestia = {
          enable = true;
          package = shellPkgs.with-cli.override {
            caelestia-cli = patchedCli;
          };
          systemd = {
            enable = false;
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
            package = patchedCli;
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
      }
    ))
  ];
}
