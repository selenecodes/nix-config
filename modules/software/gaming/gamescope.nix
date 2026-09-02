{gaming, ...}: {
  repository.features = [
    (gaming.nixos {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
    })
  ];
}
