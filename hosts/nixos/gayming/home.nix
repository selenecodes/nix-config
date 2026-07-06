{ ... }: {
  home.stateVersion = "25.11";
  home.file.".zshrc".source = ./home/files/.zshrc;
  home.file.".face".source = ../../../assets/avatars/yachiyo.png;
  xdg.configFile."niri/config.kdl".source = ./home/niri-default-config.kdl;
}
