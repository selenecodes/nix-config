{ lib, config, ... }:
lib.mkIf config.myconfig.isPersonal {
  homebrew.casks = [
    "betterdisplay"
    "bettermouse"
    "cleanshot"
    "soundsource"
  ];
}
