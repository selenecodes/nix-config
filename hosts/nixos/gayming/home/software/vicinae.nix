{ pkgs, inputs, ... }:

{
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
      # consider_preedit = true;
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
    # # extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
    # #   bluetooth
    # #   nix
    # #   # Extension names can be found in https://github.com/vicinaehq/extensions/tree/main/extensions
    # # ];
  };
}
