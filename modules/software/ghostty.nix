_: {
  homeManager.base = {
    pkgs,
    lib,
    ...
  }: {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      package =
        if pkgs.stdenv.hostPlatform.isDarwin
        then pkgs.ghostty-bin
        else pkgs.ghostty;
      settings =
        {
          adjust-cell-height = "10%";
          confirm-close-surface = false;
          copy-on-select = true;
          font-size = 16;
          font-thicken = true;
          mouse-hide-while-typing = true;
          quit-after-last-window-closed = true;
          scrollback-limit = 1000000;
          window-padding-y = 0;
          window-padding-x = 0;
          window-padding-color = "extend";
          window-padding-balance = true;
          window-save-state = "always";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          macos-non-native-fullscreen = false;
          macos-option-as-alt = true;
        };
    };
  };
}
