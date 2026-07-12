_: {
  homeManager.base = _: {
    home.file = {
      ".condarc".source = ./files/.condarc;
      ".p10k.zsh".source = ./files/.p10k.zsh;
    };
  };
  homeManager.work = _: {
    home.file.".config/pip/pip.conf".source = ./files/work/pip.conf;
  };
}
