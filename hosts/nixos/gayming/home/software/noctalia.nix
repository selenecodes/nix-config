{ inputs, ... }:

{
  programs.noctalia = {
    enable = true;

    settings = { # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper.default.path = "${../../../../../assets/wallpapers/kaguya-iroha-yachiyo.png}";
    };
  };
}