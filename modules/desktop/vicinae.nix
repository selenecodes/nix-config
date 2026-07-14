{inputs, ...}: {
  homeManager.vicinae = {
    imports = [inputs.vicinae.homeManagerModules.default];
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
