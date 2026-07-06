{ pkgs, lib, inputs, isDarwin ? false, ... }: {
  imports = lib.optionals (!isDarwin) [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
        wallpaper.default.path = "${../../../assets/wallpapers/kaguya-iroha-yachiyo.png}";
      };
    };
  };
}
