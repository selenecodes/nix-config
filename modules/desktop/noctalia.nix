{
  homeManager.noctalia = {
    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
        wallpaper.default.path = "${../assets/wallpapers/kaguya-iroha-yachiyo.png}";
      };
    };
  };
}
