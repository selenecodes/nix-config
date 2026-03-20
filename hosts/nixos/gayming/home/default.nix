{ pkgs, lib, inputs, ... }:

let
  myFont = "JetBrainsMono Nerd Font";
in {
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.noctalia.homeModules.default
    # (import ../../../../shared/home/software/work/default.nix { inherit pkgs; })
    (import ./software/vicinae.nix { inherit pkgs inputs; })
  ];

  programs.noctalia-shell = {
    enable = true;
  };

  home = {
    # Shared Work
    file.".config/pip/pip.conf".source = "${../../../../modules/profiles/work/home/files/pip.conf}";
    file.".codex/config.toml".source = "${../../../../modules/profiles/work/home/files/codex-config.toml}";
    # Shared Personal
    # Shared Common
    file.".config/opencode/opencode.json".source = "${../../../../modules/profiles/common/home/files/opencode-config.json}";
    file.".condarc".source = "${../../../../modules/profiles/common/home/files/.condarc}";
    file.".p10k.zsh".source = "${../../../../modules/profiles/common/home/files/.p10k.zsh}";
    # Platform specific
    file.".zshrc".source = "${./files/.zshrc}";
    file.".face".source = "${../../../../assets/avatars/yachiyo.png}";
    file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
      defaultWallpaper = "${../../../../assets/wallpapers/kaguya-iroha-yachiyo.png}";
      wallpapers = {
        "DP-1" = "${../../../../assets/wallpapers/kaguya-iroha-yachiyo.png}";
        "DP-2" = "${../../../../assets/wallpapers/kaguya-iroha-yachiyo.png}";
      };
    };
  };

  home.packages = with pkgs; [
    inputs.noctalia-qs.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Wayland / desktop tools
    wl-clipboard
    cliphist
    grim           # screenshots
    slurp          # screenshot region selection
    xwayland-satellite  # X11 app compatibility
    wf-recorder    # screen recording
    easyeffects    # PipeWire audio effects

    # Terminal & productivity
    nautilus
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";  # Electron/Wayland support (discord, etc.)
  };

  xdg.enable = true;

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 78;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

  # Niri compositor config
  xdg.configFile."niri/config.kdl".source = "${./niri-default-config.kdl}";
  #xdg.configFile."niri/config.kdl".text = ''
  #  input {
  #    keyboard {
  #      xkb {
  #        layout "us"
  #      }
  #    }
  #    focus-follows-mouse
  #  }
  #
  #  output "DP-2" {
  #    mode "3840x2160@60.000"
  #    scale 1.25
  #    position x=0 y=0
  #  }
  #
  #  output "DP-1" {
  #    mode "3440x1440@120.000"
  #    scale 1.0
  #    position x=3072 y=0
  #  }
  #
  #  layout {
  #    gaps 10
  #    border {
  #      width 2
  #    }
  #  }
  #
  #  prefer-no-csd
  #
  #  window-rule {
  #    geometry-corner-radius 10
  #    clip-to-geometry true
  #  }
  #
  #  spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"
  #  spawn-at-startup "qs" "-c" "noctalia-shell" "-d"
  #  spawn-at-startup "easyeffects" "--gapplication-service"
  #  spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
  #  spawn-at-startup "xwayland-satellite"
  #
  #  binds {
  #   Mod+T { spawn "ghostty"; }
  #    Mod+Q { close-window; }
  #    Mod+F { fullscreen-window; }
  #    Mod+B { toggle-window-floating; }
  #    Mod+E { spawn "nautilus"; }
  #    Mod+L { spawn "noctalia-shell" "lock"; }
  #    Mod+Space { spawn "vicinae" "open"; }
  #    Mod+H { spawn "vicinae" "deeplink" "vicinae://extensions/vicinae/clipboard/history"; }
  #    Alt+Tab { focus-window-down-or-column-right; }
  #    Print { spawn "bash" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
  #  }
  #'';

  services.network-manager-applet.enable = true;
}
