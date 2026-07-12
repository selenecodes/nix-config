_: {
  homeManager.base = _: {
    home.file = {
      ".condarc".source = ./files/.condarc;
    };
  };
  homeManager.work = _: {
    home.file.".config/pip/pip.conf".source = ./files/work/pip.conf;
  };
}
