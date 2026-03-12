{ pkgs, lib, ... }:
# On Darwin: ghostty is managed by Homebrew (pkgs.ghostty is broken on macOS),
# so we use a mock to let home-manager manage settings without installing the package.
# On Linux: use the real nixpkgs package.
let
  ghostty-mock = pkgs.writeShellScriptBin "ghostty-mock" ''
    true
  '';
in {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = if pkgs.stdenv.isDarwin then ghostty-mock else pkgs.ghostty;
    settings = {
      adjust-cell-height = "10%";
      confirm-close-surface = false;
      copy-on-select = true;
      font-size = 16;
      font-thicken = true;
      mouse-hide-while-typing = true;
      quit-after-last-window-closed = true;
      scrollback-limit = 1000000;
      theme = "Catppuccin Frappe";
      window-padding-y = 0;
      window-padding-x = 0;
      window-padding-color = "extend";
      window-padding-balance = true;
      window-save-state = "always";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      macos-non-native-fullscreen = false;
      macos-option-as-alt = true;
    };
  };
}
