{ pkgs, ... }:
# Add ghostty mock since we're managing it through homebrew and the
# pkgs.ghostty is marked as broken on macos.
# Problem: https://github.com/NixOS/nixpkgs/issues/388984#issuecomment-2715508998
# Solution: https://github.com/nix-community/home-manager/issues/6295
let
  ghostty-mock = pkgs.writeShellScriptBin "gostty-mock" ''
    true
    '';
in {  
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = ghostty-mock;
    settings = {
      adjust-cell-height = "10%";
      confirm-close-surface = false;
      copy-on-select = true;
      font-size = 16;
      font-thicken = true;
      mouse-hide-while-typing = true;
      macos-non-native-fullscreen=false;
      macos-option-as-alt = true;
      # macos-titlebar-style = "hidden";
      quit-after-last-window-closed = true;
      scrollback-limit = 1000000;
      theme = "Catppuccin Frappe";
      window-padding-y = 0;
      window-padding-x = 0;
      window-padding-color = "extend";
      window-padding-balance = true;
      window-save-state = "always";
    };
  };
}
