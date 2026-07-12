{
  pkgs,
  lib,
  inputs,
  isDarwin ? false,
  ...
}: {
  imports = lib.optionals (!isDarwin) [
    inputs.vicinae.homeManagerModules.default
  ];

  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
      settings = {
        pop_to_root_on_close = true;
        search_files_in_root = true;
        theme = {
          light.name = "catppuccin-frappe";
          dark.name = "catppuccin-frappe";
        };
        launcher_window = {
          opacity = 0.98;
        };
      };
    };
  };
}
