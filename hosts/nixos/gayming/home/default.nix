{ pkgs, lib, inputs, ... }:

let
  myFont = "JetBrainsMono Nerd Font";
in {
  imports = [
    inputs.vicinae.homeManagerModules.default
    (import ../../../../shared/home/software/common/default.nix { inherit pkgs myFont; })
    # (import ../../../../shared/home/software/work/default.nix { inherit pkgs; })
    (import ./software/vicinae.nix { inherit pkgs inputs; })
  ];

  home = {
    # Shared Work
    file.".config/pip/pip.conf".source = "${../../../../shared/home/files/work/pip.conf}";
    file.".codex/config.toml".source = "${../../../../shared/home/files/work/codex-config.toml}";
    # Shared Personal
    # Shared Common
    file.".config/opencode/opencode.json".source = "${../../../../shared/home/files/common/opencode-config.json}";
    file.".ssh/config".source = "${../../../../shared/home/files/common/ssh-config}";
    file.".condarc".source = "${../../../../shared/home/files/common/.condarc}";
    file.".p10k.zsh".source = "${../../../../shared/home/files/common/.p10k.zsh}";
    # Platform specific
    file.".zshrc".source = "${./files/.zshrc}";
  };

  home.packages = with pkgs; [
    # Wayland / desktop tools
    waybar
    mako           # notifications
    wl-clipboard
    cliphist
    hyprpaper
    hypridle
    hyprlock
    grimblast      # screenshots
    wf-recorder    # screen recording
    easyeffects    # PipeWire audio effects

    # Terminal & productivity
    nautilus

    # Python env manager (replaces miniconda cask)
    conda
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
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

  # Hyprland config — customise monitors/workspaces to your setup
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = null;
    portalPackage = null;
    systemd = { enable = true; variables = [ "--all" ]; };
    settings = {
      "$mod" = "SUPER";
      general = { gaps_out = 10; allow_tearing = true; };
      input.follow_mouse = 2;
      misc = {
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      render.direct_scanout = 2;
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "mako"
        "easyeffects --gapplication-service"
        "waybar"
        "wl-paste --watch cliphist store"
      ];
      monitor = [
        # 4K Monitor (Left) - Positioned at 0,0
        # Using 150% scaling to make text more readablep
        "DP-2, 3840x2160@60, 0x0, 1.25"
        # Ultrawide (Right) - Positioned to the right of the 4k monitor
        # Note: If DP-2 is scaled by 1.5, it's logical width is 3440 / 1.5 = 2293
        "DP-1, 3440x1440@120, 3072x0, 1"
      ];
      bind = [
        "$mod, T, exec, ghostty"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen"
        "$mod, B, togglefloating,"
        "$mod, E, exec, nautilus"
        "$mod, L, exec, hyprlock"
        "$mod, Space, exec, vicinae open"
        "$mod, H, exec, vicinae deeplink vicinae://extensions/vicinae/clipboard/history"
        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"
        ", Print, exec, grimblast copy area"
        "$mod SHIFT, A, resizeactive, -30 0"
        "$mod SHIFT, D, resizeactive, 30 0"
        "$mod SHIFT, W, resizeactive, 0 -30"
        "$mod SHIFT, S, resizeactive, 0 30"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.waybar.enable = true;

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      layer = "top";
      default-timeout = 5000;
    };
  };

  services.network-manager-applet.enable = true;
}
