{ lib, isWork ? false, ... }: {
  home.file = {
    ".condarc".source = ./files/.condarc;
    ".p10k.zsh".source = ./files/.p10k.zsh;
    ".config/pip/pip.conf" = lib.mkIf isWork { source = ./files/work/pip.conf; };
  };
}
