{gaymingNixosTargets, ...}: {
  repository.features = [
    {
      nixos = {
        targets = gaymingNixosTargets;
        module = {lib, ...}: {
          programs.gamemode = {
            enable = true;
            settings = {
              general.renice = 10;
              gpu = {
                apply_gpu_optimisations = "accept-responsibility";
                gpu_device = 0;
                nv_powermizer_mode = 1;
              };
            };
          };

          # gamemoded starts before D-Bus exists in the greeter session without this
          systemd.user.services.gamemoded.wantedBy = lib.mkForce ["graphical-session.target"];
        };
      };
    }
  ];
}
