{ lib, isWork ? false, ... }: {
  home.file.".config/opencode/opencode.json".source = ./files/opencode-config.json;
  home.file.".condarc".source = ./files/.condarc;
  home.file.".p10k.zsh".source = ./files/.p10k.zsh;

  home.file.".config/pip/pip.conf" = lib.mkIf isWork { source = ./files/work/pip.conf; };
}
