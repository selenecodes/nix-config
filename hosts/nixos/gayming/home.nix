_: {
  home = {
    stateVersion = "25.11";
    file.".zshrc".source = ./home/files/.zshrc;
    file.".face".source = ../../../assets/avatars/yachiyo.png;
  };
  xdg.configFile."niri/config.kdl".source = ./home/niri-default-config.kdl;
}
