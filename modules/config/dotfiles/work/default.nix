_: {
  repository.features = [
    {
      homeManager = {
        targets = ["rwslaptop" "studio"];
        module.home.file.".config/pip/pip.conf".source = ./pip.conf;
      };
    }
  ];
}
